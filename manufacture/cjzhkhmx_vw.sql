create or replace view cjzhkhmx_vw as
select rq,
       ygqc,
       ffzl,
       zf,
       kjsj,
       sc,
       case
         when sc <  (select cp1 from cjcs_tb where csm='ʱ��') then
          (select v1 from cjcs_tb where csm='ʱ��')--�ɵ�����

         when sc between (select cp1 from cjcs_tb where csm='ʱ��') and (select cp2 from cjcs_tb where csm='ʱ��') then
          (select v2 from cjcs_tb where csm='ʱ��')

         when sc > (select cp2 from cjcs_tb where csm='ʱ��') then
          (select v3 from cjcs_tb where csm='ʱ��')
       end scfs,
       cfl,
       case
         when cfl < (select cp1 from cjcs_tb where csm='������') then
          (select v1 from cjcs_tb where csm='������')

         when cfl between (select cp1 from cjcs_tb where csm='������') and (select cp2 from cjcs_tb where csm='������') then
          (select v2 from cjcs_tb where csm='������')

         when cfl > (select cp2 from cjcs_tb where csm='������') then
          (select v3 from cjcs_tb where csm='������')
       end cflfs,
       zdh,
       dfdh,
       case
         when dfdh< (select cp1 from cjcs_tb where csm='���') then
          (select v1 from cjcs_tb where csm='���')

         when dfdh >=(select cp1 from cjcs_tb where csm='���')then
         (select v2 from cjcs_tb where csm='���')
       end dhfs,

       kf1,
       kf2,
       kf3
  from (select kq.ygqc,
               kq.rq,
               tj.fFzl,
               tj.zf,
               round(tj.ffzl / decode(kjsj,0,null,kjsj), 2) sc,
               tz.kjsj,
               round(100 * tj.ZF / decode(tj.FFZL,0,null,tj.ffzl), 2) cfl,
               tj.ZDH,
               round(tj.zdh / decode(tj.zf,0,null,tj.zf), 2) dfdh,
               kf.kf1,
               kf.kf2,
               kf.kf3
          from (select ygqc, rq, bc from cjkq_tb where bc is not null) kq

          left join cjsctj_vw tj on to_char(kq.rq, 'yyyymmdd') = tj.RQ
                                and kq.bc = tj.BC
          left join (select rq, bc, sum(kjsj)kjsj
  from (select trunc(bt.rq) rq, substr(bt.bc,1,2) bc, tz.kjsj, tz.tjsj, tz.cx
          from cjtz_tb tz
          left join CJTZBT_TB bt on tz.fid = bt.id)
group by rq,bc) tz on kq.rq = tz.rq
                                        and kq.bc = tz.bc
          left join cjkf_tb kf on kq.ygqc = kf.ygqc
                              and kq.rq = kf.rq)

