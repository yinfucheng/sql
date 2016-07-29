create or replace view cjduibaogz_vw as
with
r1 as
(select bt.rq, bt.bc, db.cfp,db.xfp,db.cf,db.fp,db.djlx,db.ygxm
  from cjdbcl_tb db
  left join cjdbclbt_tb bt on bt.id = db.fid),

r2 as
 (
select r1.rq,
       r1.bc,
       decode(r1.bc, 1, -1, 2, -1, 1) sfzb,
       r1.ygxm,
       round((select v1 from cjcs_tb where csm='粗麸堆包工价') * t.cfp / t2.rs, 2) cfpgz,
       round((select v1 from cjcs_tb where csm='细麸堆包工价') * t.xfcf / t2.rs, 2) xfcfgz,
       round(nvl((select v1 from cjcs_tb where csm='粗麸堆包工价') * t.cfp / t2.rs, 0) + nvl((select v1 from cjcs_tb where csm='细麸堆包工价') * t.xfcf / t2.rs, 0), 2) gz
  from r1
  left join (select rq,
                    bc,
                    nvl(sum(0.04 * cfp),0)+nvl(sum(0.05*fp),0) cfp,--16年3月30日修改，认为50kg麸皮堆包工价和40公斤相同
                    nvl(sum(0.035 * xfp), 0) + nvl(sum(0.035 * cf), 0) xfcf
               from r1
              where djlx = 0
              group by rq, bc) t on t.rq = r1.rq
                                and t.bc = r1.bc

  left join (select count(8) rs, rq, bc
               from r1
              where djlx = 1
              group by rq, bc) t2 on t2.rq = r1.rq
                                 and t2.bc = r1.bc
 where r1.djlx = 1),

duibao as--每日堆包工资数据集
 (select  1 djlx,nvl(t1.rq,t2.rq)rq, nvl( t1.ygxm,t2.ygxm)ygxm, t1.zbgz, t2.jbgz
   from (select rq, ygxm, sum(gz) zbgz from r2 where sfzb = 1 group by rq,ygxm) t1
   full  join (select rq, ygxm, sum(gz) jbgz from r2 where sfzb = -1 group by rq,ygxm) t2 on t1.rq =
                                                                 t2.rq
                                                             and t1.ygxm =
                                                                 t2.ygxm)

select djlx,rq,ygxm,zbgz,jbgz from duibao
union all
--每日打包工资数据集
select 0 djlx,nvl(zb.rq, jb.rq) rq, nvl(zb.ygxm, jb.ygxm) ygxm, zb.zbgz, jb.zbgz
  from (select rq, ygxm, gz zbgz
          from (select bt.rq,
                       decode(bt.bc, 1, -1, 2, -1, 1) sfzb,
                       sum((select v1 from cjcs_tb where csm='打包工价') * (nvl(0.05*db.fp, 0)+nvl(0.04*db.cfp, 0) + nvl(0.035*db.xfp, 0) +
                                nvl(0.035*db.cf, 0))) gz,
                       db.ygxm
                  from cjdbcl_tb db
                  left join cjdbclbt_tb bt on bt.id = db.fid
                 where db.djlx = 0
                 group by rq, ygxm, decode(bt.bc, 1, -1, 2, -1, 1))
         where sfzb = 1) zb
  full join (select rq, ygxm, gz zbgz
               from (select bt.rq,
                            decode(bt.bc, 1, -1, 2, -1, 1) sfzb,
                            sum((select v1 from cjcs_tb where csm='打包工价') * (nvl(0.05*db.fp, 0)+nvl(0.04*db.cfp, 0) + nvl(0.035*db.xfp, 0) +
                                nvl(0.035*db.cf, 0))) gz,
                            db.ygxm
                       from cjdbcl_tb db
                       left join cjdbclbt_tb bt on bt.id = db.fid
                      where db.djlx = 0
                      group by rq, ygxm, decode(bt.bc, 1, -1, 2, -1, 1))
              where sfzb = -1) jb on zb.rq = jb.rq
                                 and zb.ygxm = jb.ygxm

