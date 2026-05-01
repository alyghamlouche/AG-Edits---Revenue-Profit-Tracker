-- ================================================================
-- AG Edits Dashboard — Supabase Setup
-- Run this entire file once in your Supabase SQL Editor
-- Project Settings → SQL Editor → New query → paste → Run
-- ================================================================


-- 1. CREATE THE CLIENTS TABLE
-- ----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS clients (
  id                BIGSERIAL    PRIMARY KEY,
  name              TEXT         NOT NULL,
  source            TEXT         DEFAULT 'Other',
  package_videos    INTEGER      DEFAULT 0,
  package_price     NUMERIC(10,2) DEFAULT 0,
  editor_cost       NUMERIC(10,2) DEFAULT 0,
  deposit_paid      BOOLEAN      DEFAULT FALSE,
  deposit_paid_date DATE,
  deposit_due_date  DATE,
  final_paid        BOOLEAN      DEFAULT FALSE,
  final_paid_date   DATE,
  final_due_date    DATE,
  delivery_deadline DATE,
  is_repeat         BOOLEAN      DEFAULT FALSE,
  notes             TEXT         DEFAULT '',
  created_at        TIMESTAMPTZ  DEFAULT NOW(),
  updated_at        TIMESTAMPTZ  DEFAULT NOW()
);


-- 2. AUTO-UPDATE updated_at ON EVERY ROW CHANGE
-- ----------------------------------------------------------------
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_updated_at
  BEFORE UPDATE ON clients
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();


-- 3. ENABLE ROW LEVEL SECURITY  (required by Supabase)
-- ----------------------------------------------------------------
ALTER TABLE clients ENABLE ROW LEVEL SECURITY;


-- 4. ALLOW FULL ACCESS VIA THE ANON KEY
--    This is correct for a personal dashboard with no user auth.
--    The anon key is already scoped to this project only.
-- ----------------------------------------------------------------
CREATE POLICY "anon_full_access" ON clients
  FOR ALL
  TO anon
  USING (true)
  WITH CHECK (true);
