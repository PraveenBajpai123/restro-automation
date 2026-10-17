-- Photo shown in the section pill and section header of the customer menu
alter table menu_categories add column if not exists image_url text;
