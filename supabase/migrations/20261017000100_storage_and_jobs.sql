-- Menu photos: public read, owner/manager upload into a folder named after their outlet id.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('menu-images', 'menu-images', true, 5242880, array['image/jpeg', 'image/png', 'image/webp', 'image/avif'])
on conflict (id) do nothing;

create policy menu_images_read on storage.objects for select using (bucket_id = 'menu-images');

create policy menu_images_write on storage.objects for insert to authenticated
  with check (bucket_id = 'menu-images' and public.has_role(((storage.foldername(name))[1])::uuid, '{owner,manager}'));

create policy menu_images_update on storage.objects for update to authenticated
  using (bucket_id = 'menu-images' and public.has_role(((storage.foldername(name))[1])::uuid, '{owner,manager}'));

create policy menu_images_delete on storage.objects for delete to authenticated
  using (bucket_id = 'menu-images' and public.has_role(((storage.foldername(name))[1])::uuid, '{owner,manager}'));

-- Cancel Razorpay orders left unpaid for 15 minutes (returns any coins they burned).
create extension if not exists pg_cron with schema pg_catalog;
select cron.schedule('expire-stale-payments', '* * * * *', $$select public.expire_stale_payments(15)$$);
