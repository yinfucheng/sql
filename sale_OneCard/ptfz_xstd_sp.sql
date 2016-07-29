create or replace procedure ptfz_xstd_sp(p_id in number,p_zdrid in number)--∆’Õ®∏¥÷∆
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
  -- ytdid,
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
         /*case
           when ytdid is null then
            id
           else
            ytdid
         end,*/
         xshtid,
         seqcard.nextval
    from xstd_tb
   where id = p_id;

insert into xstdmx_tb
    (id,
     fid,
     xshtmxid,
     wlid,
     ph,
     pm,
     ggxh,
     jldwid,
     xsjldwid,
     sl,
     bs,
     yzbs,
     yzds,
     dj,
     bjdj)
    select seqxstdmx.nextval,
           seqxstd.currval,
           xshtmxid,
           wlid,
           ph,
           pm,
           ggxh,
           jldwid,
           xsjldwid,
           sl,
           bs,
           yzbs,
           yzds,
           dj,
           bjdj
      from xstdmx_tb
     where fid = p_id;

   commit;
   exception
  when others then rollback;
   end ptfz_xstd_sp;
/
