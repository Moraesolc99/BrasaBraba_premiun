-- Brasa Braba: tabela de datas reservadas.
-- Autoriza os dois usuários administrativos informados pelo responsável do projeto.
-- Desative o cadastro público em Authentication > Providers > Email.

create table if not exists public.reserved_dates (
  event_date date primary key,
  created_at timestamptz not null default now(),
  created_by uuid not null references auth.users(id)
);

alter table public.reserved_dates enable row level security;

grant select on public.reserved_dates to anon, authenticated;
grant insert, delete on public.reserved_dates to authenticated;

drop policy if exists "Public can read reserved dates" on public.reserved_dates;
create policy "Public can read reserved dates"
on public.reserved_dates
for select
to anon, authenticated
using (true);

drop policy if exists "Only Brasa Braba admins can add dates" on public.reserved_dates;
create policy "Only Brasa Braba admins can add dates"
on public.reserved_dates
for insert
to authenticated
with check (
  auth.uid() in (
    '3bcc8f2b-1bd5-4552-907c-53c9a156853a'::uuid,
    'e601bdfe-c377-411c-9cd8-28daaa09cdaa'::uuid
  )
  and created_by = auth.uid()
  and event_date >= current_date
);

drop policy if exists "Only Brasa Braba admins can remove dates" on public.reserved_dates;
create policy "Only Brasa Braba admins can remove dates"
on public.reserved_dates
for delete
to authenticated
using (
  auth.uid() in (
    '3bcc8f2b-1bd5-4552-907c-53c9a156853a'::uuid,
    'e601bdfe-c377-411c-9cd8-28daaa09cdaa'::uuid
  )
);
