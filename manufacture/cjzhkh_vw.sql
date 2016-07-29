create or replace view cjzhkh_vw as
select t.rq,
       t.ygqc,
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
      15-nvl( kf1,0) df1,
      10-nvl( kf2,0) df2,
       20-nvl(kf3,0) df3,

         case when cjllks_tb.fs<(select cp1 from cjcs_tb where csm='���Լӷ�') then (select v1 from cjcs_tb where csm='���Լӷ�')
       when cjllks_tb.fs between (select cp1 from cjcs_tb where csm='���Լӷ�') and (select cp2 from cjcs_tb where csm='���Լӷ�') then
       (select v2 from cjcs_tb where csm='���Լӷ�')
       when cjllks_tb.fs>(select cp2 from cjcs_tb where csm='���Լӷ�') then (select v3 from cjcs_tb where csm='���Լӷ�')
       end ksjf
  from
  (select ygqc,
       to_char(rq, 'yyyymm') rq,
       sum(ffzl) ffzl,
       sum(zf) zf,
       sum(kjsj) kjsj,
       round(sum(ffzl) / sum(kjsj), 2) sc,
       round(100 * sum(zf) / sum(ffzl), 2) cfl,
       sum(zdh) zdh,
       round(sum(zdh) / sum(zf), 2) dfdh,
       sum(kf1) kf1,
       sum(kf2) kf2,
       sum(kf3) kf3

  from (select kq.ygqc,
               kq.rq,
               tj.fFzl,
               tj.zf,
               --round(tj.zf / kjsj, 2) sc,
               tz.kjsj,
               --round(100 * tj.ZF / tj.FFZL, 2) cfl,
               tj.ZDH,
               --round(tj.zdh / tj.zf, 2) dfdh,
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
 where nvl(kjsj,0)>0--1��5�������
 group by ygqc, to_char(rq, 'yyyymm')) t
 left join cjllks_tb on t.ygqc=cjllks_tb.ygqc and t.rq=to_char(cjllks_tb.rq,'yyyymm')

