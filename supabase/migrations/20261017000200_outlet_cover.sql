-- Banner photo shown at the top of the customer menu
alter table outlets add column if not exists cover_url text;
