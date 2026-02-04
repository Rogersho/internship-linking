-- STEP 1: Drop ALL triggers and functions first
DROP TRIGGER IF EXISTS on_auth_user_created_company ON auth.users;
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
DROP FUNCTION IF EXISTS public.handle_new_company() CASCADE;
DROP FUNCTION IF EXISTS public.handle_new_user() CASCADE;

-- STEP 2: Drop and recreate tables to ensure clean state
DROP TABLE IF EXISTS public.applications CASCADE;
DROP TABLE IF EXISTS public.internships CASCADE;
DROP TABLE IF EXISTS public.companies CASCADE;
DROP TABLE IF EXISTS public.students CASCADE;

-- STEP 3: Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- STEP 4: Create tables
CREATE TABLE public.companies (
    id UUID PRIMARY KEY,
    name TEXT NOT NULL,
    logo_url TEXT,
    description TEXT,
    industry TEXT,
    contact_info TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE public.students (
    id UUID PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT,
    university TEXT,
    course TEXT,
    registration_number TEXT UNIQUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE public.internships (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    company_id UUID NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    requirements TEXT,
    duration TEXT,
    location TEXT,
    deadline TIMESTAMP WITH TIME ZONE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE public.applications (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    internship_id UUID NOT NULL REFERENCES public.internships(id) ON DELETE CASCADE,
    student_id UUID,
    student_name TEXT NOT NULL,
    email TEXT NOT NULL,
    phone TEXT,
    university TEXT NOT NULL,
    course TEXT NOT NULL,
    motivation TEXT,
    registration_number TEXT NOT NULL,
    status TEXT DEFAULT 'under_review' CHECK (status IN ('under_review', 'accepted', 'rejected')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(internship_id, registration_number)
);

-- STEP 5: Create indexes
CREATE INDEX idx_applications_registration_number ON public.applications(registration_number);
CREATE INDEX idx_internships_company_id ON public.internships(company_id);

-- STEP 6: Enable RLS
ALTER TABLE public.companies ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.students ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.internships ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.applications ENABLE ROW LEVEL SECURITY;

-- STEP 7: Create SIMPLE policies (no restrictions for now)
-- Companies
CREATE POLICY "allow_all_companies" ON public.companies FOR ALL USING (true) WITH CHECK (true);

-- Students  
CREATE POLICY "allow_all_students" ON public.students FOR ALL USING (true) WITH CHECK (true);

-- Internships
CREATE POLICY "allow_all_internships" ON public.internships FOR ALL USING (true) WITH CHECK (true);

-- Applications
CREATE POLICY "allow_all_applications" ON public.applications FOR ALL USING (true) WITH CHECK (true);

-- STEP 8: Storage buckets
INSERT INTO storage.buckets (id, name, public)
VALUES ('company_logos', 'company_logos', true)
ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.buckets (id, name, public)
VALUES ('documents', 'documents', false)
ON CONFLICT (id) DO NOTHING;
