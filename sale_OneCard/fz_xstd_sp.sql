create or replace procedure fz_xstd_sp(p_id in number,p_zdrid in number)--用于加单中的复制，通过ytdid联系前面的单据
as
p_djbh varchar2(50);
begin
select GET_XSTD_DJBH_FC() into P_djbh from dual;
insert into xstd_tb
  (id,
   tdbh,
   dwid,
   addr,
   tele,
   djzt,
   yxzdrid,
   zdrq,
   cch,
   ccyj,
   fkfs,
   jhrq,
   fplx,
   djlx,
   ytdid,
   xshtid,
   cardid)
  select seqxstd.nextval,
         p_djbh,
         dwid,
         addr,
         tele,
         0,
         p_zdrid,
         sysdate,
         cch,
         ccyj,
         fkfs,
         sysdate,
         fplx,
         djlx,
         case
           when ytdid is null then
            id
           else
            ytdid
         end,
         xshtid,
         cardid
    from xstd_tb
   where id = p_id;
   commit;
   exception
  when others then rollback;
   end fz_xstd_sp;
/
