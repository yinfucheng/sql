create or replace view cjmztzmx1_vw as
with t2 as
(select to_char(rq, 'yyyymmdd') rq,bc,bl,sum(zf)+sum(fcpdbcl) zff from SCGLRB_TB group by rq,bc,bl)

select ygqc,
       rq,
       zbcl,
       round((select v1 from CJCS_TB where csm = '产量工价') * zbcl, 2) zbclgz,
       jbcl,
       round((select v1 from CJCS_TB where csm = '产量工价') * jbcl, 2) jbclgz,
       zbcl + jbcl zcl,
       round((select v1 from CJCS_TB where csm = '产量工价') * (zbcl + jbcl),
             2) zclgz
  from (select ygqc,
               rq,
               round(decode(sum(zbcl), null, 0, sum(zbcl)), 2) zbcl,
               round(decode(sum(jbcl), null, 0, sum(jbcl)), 2) jbcl
          from (select ygqc,
                       t3.rq,
                       t3.bc,
                       t3.bl,
                       zbcl,
                       (zff * t3.djxs) jbcl
                  from (select ygqc,
                               t1.rq,
                               t1.bc,
                               t1.djxs,
                               t1.bl,
                               (zff * t1.djxs) zbcl
                          from cjkq2_vw t1
                          left join t2
                            on t2.rq = to_char(t1.rq, 'yyyymmdd')
                           and t1.bc = t2.bc
                           and t1.bl = '正班') t3
                  left join t2
                    on t2.rq = to_char(t3.rq, 'yyyymmdd')
                   and t3.bc = t2.bc
                   and t3.bl = '加班')
         group by ygqc, rq)
         order by rq desc,ygqc

