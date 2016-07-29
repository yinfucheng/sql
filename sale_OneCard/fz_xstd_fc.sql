create or replace function fz_xstd_fc(p_id in number, p_zdrid in number)
--by YFC 用于改单中的复制，复制完成后将清除原单据中的cardid以适用于加单后改单的流程,同时返回被复制提单的ID以方便写卡
 return number is
  PRAGMA AUTONOMOUS_TRANSACTION; --自治事务
  p_djbh varchar2(50);
  P_xlh  number;
begin
  select GET_XSTD_DJBH_FC() into P_djbh from dual;
  select seqxstd.nextval into p_xlh from dual;
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
     
     cardid,
     XSHTID,
     bz)
    select p_xlh,
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
           ytdid,
           
           cardid,
           XSHTID,
           bz
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
           p_xlh,
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
  update xstd_tb set ytdid = null, cardid = null where id = p_id;
  commit;
  return p_xlh;
exception
  when others then
    rollback;
    return - 1;
  
end fz_xstd_fc;
/
