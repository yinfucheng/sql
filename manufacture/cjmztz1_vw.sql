create or replace view cjmztz1_vw as
select tz.ygqc,tz.rq,tz.zbcl,tz.zbclgz,cq.zbts,tz.jbcl,tz.jbclgz,cq.jbts,tz.zcl,tz.zclgz,tz.sbts from
(select ygqc,
       rq,
       max(zbts) sbts,--上班天数
       sum(case when zbts >26 then 0 else zbcl end) zbcl,
       sum(case when zbts >26 then 0 else zbclgz end) zbclgz,
       sum(case when zbts >26 then zbcl+jbcl else jbcl end) jbcl,
       sum(case when zbts >26 then zbclgz+jbclgz else jbclgz end ) jbclgz,
       sum(zcl) zcl,
       sum(zclgz) zclgz
        from(select ygqc,
               to_char(rq, 'yyyy-mm') rq,
               --rq rq1,
               zbcl,
               zbclgz,
               jbcl,
               jbclgz,
               zcl,
               zclgz,
               count(zbcl ) over(partition by ygqc,to_char(rq,'yyyymm') order by rq) zbts--计算正班天数
          from cjmztzmx1_vw )
          --where ygqc='殷强'
          --order by rq1
         group by ygqc, rq
) tz
left join
(select nvl(zb.ygqc,jb.ygqc)ygqc,nvl(zb.rq,jb.rq)rq,zb.zbts,jb.jbts from
(select ygqc, to_char(rq, 'yyyy-mm') rq, count(9) zbts
  from cjkq_tb
 where bl = '正班'
 group by ygqc, to_char(rq, 'yyyy-mm')) zb
  full join
(select ygqc, to_char(rq, 'yyyy-mm') rq, count(9) jbts
  from cjkq_tb
 where bl = '加班'
 group by ygqc, to_char(rq, 'yyyy-mm'))jb
 on zb.ygqc=jb.ygqc and zb.rq=jb.rq)cq on tz.ygqc=cq.ygqc and tz.rq=cq.rq

