-- WARNING: This schema is for context only and is not meant to be run.
-- Table order and constraints may not be valid for execution.

CREATE TABLE public.accounts (
  id character varying NOT NULL DEFAULT gen_random_uuid(),
  account_code text NOT NULL UNIQUE,
  account_name text NOT NULL,
  account_type text NOT NULL,
  parent_account_id character varying,
  balance numeric DEFAULT '0'::numeric,
  status text DEFAULT 'active'::text,
  created_at timestamp without time zone DEFAULT now(),
  CONSTRAINT accounts_pkey PRIMARY KEY (id)
);
CREATE TABLE public.applications (
  id character varying NOT NULL DEFAULT gen_random_uuid(),
  job_posting_id character varying NOT NULL,
  candidate_name text NOT NULL,
  email text NOT NULL,
  phone text,
  resume text,
  cover_letter text,
  status text DEFAULT 'applied'::text,
  applied_date date DEFAULT now(),
  created_at timestamp without time zone DEFAULT now(),
  CONSTRAINT applications_pkey PRIMARY KEY (id)
);
CREATE TABLE public.attendance (
  id character varying NOT NULL DEFAULT gen_random_uuid(),
  employee_id character varying NOT NULL,
  date date NOT NULL,
  check_in timestamp without time zone,
  check_out timestamp without time zone,
  status text DEFAULT 'present'::text,
  notes text,
  created_at timestamp without time zone DEFAULT now(),
  CONSTRAINT attendance_pkey PRIMARY KEY (id)
);
CREATE TABLE public.chat_members (
  room_id uuid NOT NULL,
  user_id uuid NOT NULL,
  joined_at timestamp with time zone NOT NULL DEFAULT now(),
  last_seen_at timestamp with time zone,
  CONSTRAINT chat_members_pkey PRIMARY KEY (room_id, user_id),
  CONSTRAINT chat_members_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.chat_rooms(id),
  CONSTRAINT chat_members_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id)
);
CREATE TABLE public.chat_rooms (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  type text NOT NULL CHECK (type = ANY (ARRAY['private'::text, 'group'::text])),
  title text,
  created_by uuid NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT chat_rooms_pkey PRIMARY KEY (id),
  CONSTRAINT chat_rooms_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id)
);
CREATE TABLE public.customers (
  id character varying NOT NULL DEFAULT gen_random_uuid(),
  name text NOT NULL,
  email text,
  phone text,
  company text,
  address text,
  city text,
  state text,
  country text,
  postal_code text,
  status text DEFAULT 'active'::text,
  created_at timestamp without time zone DEFAULT now(),
  CONSTRAINT customers_pkey PRIMARY KEY (id)
);
CREATE TABLE public.departments (
  id character varying NOT NULL DEFAULT gen_random_uuid(),
  name text NOT NULL,
  code text NOT NULL UNIQUE,
  description text,
  head_id character varying,
  status text DEFAULT 'active'::text,
  created_at timestamp without time zone DEFAULT now(),
  CONSTRAINT departments_pkey PRIMARY KEY (id)
);
CREATE TABLE public.employees (
  id character varying NOT NULL DEFAULT gen_random_uuid(),
  employee_id text NOT NULL UNIQUE,
  first_name text NOT NULL,
  last_name text NOT NULL,
  email text NOT NULL UNIQUE,
  phone text,
  date_of_birth date,
  date_of_joining date,
  department_id character varying,
  designation text,
  reporting_to character varying,
  employment_type text,
  status text DEFAULT 'active'::text,
  address text,
  city text,
  state text,
  country text,
  postal_code text,
  created_at timestamp without time zone DEFAULT now(),
  CONSTRAINT employees_pkey PRIMARY KEY (id)
);
CREATE TABLE public.job_postings (
  id character varying NOT NULL DEFAULT gen_random_uuid(),
  title text NOT NULL,
  department_id character varying,
  description text,
  requirements text,
  location text,
  employment_type text,
  salary_range text,
  status text DEFAULT 'open'::text,
  openings integer DEFAULT 1,
  posted_date date DEFAULT now(),
  closing_date date,
  created_at timestamp without time zone DEFAULT now(),
  CONSTRAINT job_postings_pkey PRIMARY KEY (id)
);
CREATE TABLE public.leads (
  id character varying NOT NULL DEFAULT gen_random_uuid(),
  name text NOT NULL,
  email text,
  phone text,
  company text,
  source text,
  status text DEFAULT 'new'::text,
  assigned_to character varying,
  notes text,
  created_at timestamp without time zone DEFAULT now(),
  CONSTRAINT leads_pkey PRIMARY KEY (id)
);
CREATE TABLE public.leaves (
  id character varying NOT NULL DEFAULT gen_random_uuid(),
  employee_id character varying NOT NULL,
  leave_type text NOT NULL,
  start_date date NOT NULL,
  end_date date NOT NULL,
  days integer NOT NULL,
  reason text,
  status text DEFAULT 'pending'::text,
  approved_by character varying,
  approved_at timestamp without time zone,
  created_at timestamp without time zone DEFAULT now(),
  CONSTRAINT leaves_pkey PRIMARY KEY (id)
);
CREATE TABLE public.message_reads (
  message_id uuid NOT NULL,
  user_id uuid NOT NULL,
  read_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT message_reads_pkey PRIMARY KEY (message_id, user_id),
  CONSTRAINT message_reads_message_id_fkey FOREIGN KEY (message_id) REFERENCES public.messages(id),
  CONSTRAINT message_reads_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id)
);
CREATE TABLE public.messages (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  room_id uuid NOT NULL,
  sender_id uuid NOT NULL,
  content text,
  file_url text,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  seen boolean NOT NULL DEFAULT false,
  seen_at timestamp with time zone,
  CONSTRAINT messages_pkey PRIMARY KEY (id),
  CONSTRAINT messages_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.chat_rooms(id),
  CONSTRAINT messages_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES auth.users(id)
);
CREATE TABLE public.opportunities (
  id character varying NOT NULL DEFAULT gen_random_uuid(),
  name text NOT NULL,
  customer_id character varying,
  lead_id character varying,
  value numeric,
  stage text DEFAULT 'prospecting'::text,
  probability integer,
  expected_close_date date,
  assigned_to character varying,
  status text DEFAULT 'open'::text,
  notes text,
  created_at timestamp without time zone DEFAULT now(),
  CONSTRAINT opportunities_pkey PRIMARY KEY (id)
);
CREATE TABLE public.payroll (
  id character varying NOT NULL DEFAULT gen_random_uuid(),
  employee_id character varying NOT NULL,
  month text NOT NULL,
  year integer NOT NULL,
  basic_salary numeric,
  allowances numeric,
  deductions numeric,
  net_salary numeric,
  status text DEFAULT 'draft'::text,
  processed_at timestamp without time zone,
  created_at timestamp without time zone DEFAULT now(),
  CONSTRAINT payroll_pkey PRIMARY KEY (id)
);
CREATE TABLE public.products (
  id character varying NOT NULL DEFAULT gen_random_uuid(),
  sku text NOT NULL UNIQUE,
  name text NOT NULL,
  description text,
  category text,
  unit text,
  purchase_price numeric,
  selling_price numeric,
  current_stock integer DEFAULT 0,
  min_stock integer DEFAULT 0,
  max_stock integer,
  status text DEFAULT 'active'::text,
  created_at timestamp without time zone DEFAULT now(),
  CONSTRAINT products_pkey PRIMARY KEY (id)
);
CREATE TABLE public.purchase_order_items (
  id character varying NOT NULL DEFAULT gen_random_uuid(),
  purchase_order_id character varying NOT NULL,
  product_id character varying NOT NULL,
  quantity integer NOT NULL,
  unit_price numeric,
  total numeric,
  created_at timestamp without time zone DEFAULT now(),
  CONSTRAINT purchase_order_items_pkey PRIMARY KEY (id)
);
CREATE TABLE public.purchase_orders (
  id character varying NOT NULL DEFAULT gen_random_uuid(),
  order_number text NOT NULL UNIQUE,
  supplier_id character varying NOT NULL,
  order_date date DEFAULT now(),
  expected_delivery_date date,
  status text DEFAULT 'draft'::text,
  subtotal numeric,
  tax numeric,
  total numeric,
  notes text,
  created_at timestamp without time zone DEFAULT now(),
  CONSTRAINT purchase_orders_pkey PRIMARY KEY (id)
);
CREATE TABLE public.sales_order_items (
  id character varying NOT NULL DEFAULT gen_random_uuid(),
  sales_order_id character varying NOT NULL,
  product_id character varying NOT NULL,
  quantity integer NOT NULL,
  unit_price numeric,
  total numeric,
  created_at timestamp without time zone DEFAULT now(),
  CONSTRAINT sales_order_items_pkey PRIMARY KEY (id)
);
CREATE TABLE public.sales_orders (
  id character varying NOT NULL DEFAULT gen_random_uuid(),
  order_number text NOT NULL UNIQUE,
  customer_id character varying NOT NULL,
  order_date date DEFAULT now(),
  expected_delivery_date date,
  status text DEFAULT 'draft'::text,
  subtotal numeric,
  tax numeric,
  total numeric,
  notes text,
  created_at timestamp without time zone DEFAULT now(),
  CONSTRAINT sales_orders_pkey PRIMARY KEY (id)
);
CREATE TABLE public.stock_movements (
  id character varying NOT NULL DEFAULT gen_random_uuid(),
  product_id character varying NOT NULL,
  movement_type text NOT NULL,
  quantity integer NOT NULL,
  reference_type text,
  reference_id character varying,
  notes text,
  created_at timestamp without time zone DEFAULT now(),
  CONSTRAINT stock_movements_pkey PRIMARY KEY (id)
);
CREATE TABLE public.suppliers (
  id character varying NOT NULL DEFAULT gen_random_uuid(),
  name text NOT NULL,
  email text,
  phone text,
  company text,
  address text,
  city text,
  state text,
  country text,
  postal_code text,
  status text DEFAULT 'active'::text,
  created_at timestamp without time zone DEFAULT now(),
  CONSTRAINT suppliers_pkey PRIMARY KEY (id)
);
CREATE TABLE public.transactions (
  id character varying NOT NULL DEFAULT gen_random_uuid(),
  transaction_date date DEFAULT now(),
  account_id character varying NOT NULL,
  type text NOT NULL,
  amount numeric NOT NULL,
  description text,
  reference_type text,
  reference_id character varying,
  created_at timestamp without time zone DEFAULT now(),
  CONSTRAINT transactions_pkey PRIMARY KEY (id)
);
CREATE TABLE public.trips (
  id character varying NOT NULL DEFAULT gen_random_uuid(),
  trip_number text NOT NULL UNIQUE,
  vehicle_id character varying NOT NULL,
  driver_id character varying,
  origin text,
  destination text,
  start_date timestamp without time zone,
  end_date timestamp without time zone,
  status text DEFAULT 'planned'::text,
  distance numeric,
  notes text,
  created_at timestamp without time zone DEFAULT now(),
  CONSTRAINT trips_pkey PRIMARY KEY (id)
);
CREATE TABLE public.users (
  id character varying NOT NULL DEFAULT gen_random_uuid(),
  username text NOT NULL UNIQUE,
  password text NOT NULL,
  email text,
  role text DEFAULT 'user'::text,
  created_at timestamp without time zone DEFAULT now(),
  CONSTRAINT users_pkey PRIMARY KEY (id)
);
CREATE TABLE public.users_profile (
  id uuid NOT NULL,
  name text NOT NULL,
  department text,
  role text,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT users_profile_pkey PRIMARY KEY (id),
  CONSTRAINT users_profile_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id)
);
CREATE TABLE public.vehicles (
  id character varying NOT NULL DEFAULT gen_random_uuid(),
  vehicle_number text NOT NULL UNIQUE,
  vehicle_type text,
  capacity numeric,
  status text DEFAULT 'available'::text,
  created_at timestamp without time zone DEFAULT now(),
  CONSTRAINT vehicles_pkey PRIMARY KEY (id)
);




begin
  insert into public.users_profile (id, name)
  values (
    new.id,
    coalesce(nullif(new.raw_user_meta_data->>'name',''), split_part(new.email, '@', 1), 'User')
  )
  on conflict (id) do nothing;

  return new;
end;



