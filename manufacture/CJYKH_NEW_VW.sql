CREATE OR REPLACE VIEW CJYKH_NEW_VW AS
select t1.cj,--目前在用的车间月考核
               NULL rq,
               t1.jm,
               t1.f1,
               t1.f2,
               t1.f3,
               t1.xfp,
               t1.cfp,
               t1.cf,
               t1.pf1,
               t1.pf2,
               t1.pf3,
               t1.pzf,
               t1.dfdh,
               t1.zf,
               t1.ffzl,
               t1.zdh,
               t2.yzl,
               t3.maomai,
               t4.fpdb,--50公斤麸皮
               t4.cfpdb,
               t4.xfpdb,
               t4.cfdb,
               jx.jxgs,
               djwx.ts,
               djwx.kwh
          from (select decode(cx, 'A', 1, 'B', 1, 'C', 2, 'D', 2) cj,
                       sum(b1) jm,
                       sum(f1) f1,
                       sum(f2) f2,
                       sum(f3) f3,
                       sum(xfp) xfp,
                       sum(cfp) cfp,
                       sum(cf) cf,
                       round(100 * sum(f1) / sum(zf), 2) pf1,
                       round(100 * sum(f2) / sum(zf), 2) pf2,
                       round(100 * sum(f3) / sum(zf), 2) pf3,
                       round(100 * sum(zf) / sum(ffzl), 2) pzf,
                       round(sum(zdh) / sum(zf), 2) dfdh,
                       sum(zf) zf,
                       sum(ffzl) ffzl,
                       sum(zdh) zdh
                  from cjscsj_vw
                 where rq2 between to_char(to_date((SELECT KSSJ FROM CJCS_TB WHERE ID=1),
                                                   'YYYY-MM-DD hh24:mi:ss'),
                                           'yyyymmdd') AND
                       to_char(to_date((SELECT JSSJ FROM CJCS_TB WHERE ID=1),
                                       'YYYY-MM-DD hh24:mi:ss'),
                               'yyyymmdd')
                 group by decode(cx, 'A', 1, 'B', 1, 'C', 2, 'D', 2)) t1
          left join
          (select decode(cx, 'A', 1, 'B', 1, 'C', 2, 'D', 2) cj,
                           sum(kjsj) kjsj,
                           sum(tjsj) tjsj,
                           round(100 * sum(kjsj) /
                                 (sum(nvl(kjsj, 0) + nvl(tjsj, 0))),
                                 2) yzl
                      from cjtzbt_tb tzbt
                      left join cjtz_tb tzmx on tzbt.id = tzmx.fid
                     WHERE to_char(tzbt.rq, 'yyyymmdd') between
                           to_char(to_date((SELECT KSSJ FROM CJCS_TB WHERE ID=1),
                                           'YYYY-MM-DD hh24:mi:ss'),
                                   'yyyymmdd') AND
                           to_char(to_date((SELECT JSSJ FROM CJCS_TB WHERE ID=1),
                                           'YYYY-MM-DD hh24:mi:ss'),
                                   'yyyymmdd')
                     group by decode(cx, 'A', 1, 'B', 1, 'C', 2, 'D', 2)) t2 on t1.cj =
                                                                                t2.cj
          left join
          (select 1 cj, round(sum(sc_总重量 / 1000), 3) maomai
                      from sc_data.sc_sumdata1_tb
                     where sc_秤号 in (7, 8)
                       and case when to_char(sc_时间, 'hh24mi') between
                           '0000' and '082959' then to_char(sc_时间 - 1, 'yyyymmdd') else to_char(sc_时间, 'yyyymmdd') end
                           between to_char(to_date((SELECT KSSJ FROM CJCS_TB WHERE ID=1), 'YYYY-MM-DD hh24:mi:ss'), 'yyyymmdd')
						   AND to_char(to_date((SELECT JSSJ FROM CJCS_TB WHERE ID=1), 'YYYY-MM-DD hh24:mi:ss'), 'yyyymmdd')) t3 on t1.cj = t3.cj
          left join
          (select 1 cj,sum(0.05*db.fp) fpdb,sum(0.04*db.cfp) cfpdb, sum(0.035*db.xfp) xfpdb, sum(0.035*db.cf) cfdb
   from cjdbcl_tb db
   left join cjdbclbt_tb bt on bt.id = db.fid
  where db.djlx = 0
    and to_char(bt.rq, 'yyyymmdd') between
        to_char(to_date((SELECT KSSJ FROM CJCS_TB WHERE ID = 1),
                        'YYYY-MM-DD hh24:mi:ss'),
                'yyyymmdd') AND
        to_char(to_date((SELECT JSSJ FROM CJCS_TB WHERE ID = 1),
                        'YYYY-MM-DD hh24:mi:ss'),
                'yyyymmdd')) t4 on t1.cj=t4.cj
          --这个leftjoin之前为堆包数量折算为吨数的数据集
          left join
          (select 1 cj,sum(zsgs)jxgs
          from sb_jxpgd0_tb
         where zt = 3 and to_char(shrq,'yyyymmdd') between
         to_char(to_date((SELECT KSSJ FROM CJCS_TB WHERE ID = 1),
                        'YYYY-MM-DD hh24:mi:ss'),
                'yyyymmdd') AND
        to_char(to_date((SELECT JSSJ FROM CJCS_TB WHERE ID = 1),
                        'YYYY-MM-DD hh24:mi:ss'),
                'yyyymmdd')
                and sqbm='国丰车间'


            )jx on t1.cj=jx.cj
          --这个leftjoin之前为计算机修部门给车间派工的工时
          left join
          ( select 1cj,sum(ts)ts,sum(kwh)kwh from sb_djsxd_tb where to_char(shrq,'yyyymmdd') between
         to_char(to_date((SELECT KSSJ FROM CJCS_TB WHERE ID = 1),
                        'YYYY-MM-DD hh24:mi:ss'),
                'yyyymmdd') AND
        to_char(to_date((SELECT JSSJ FROM CJCS_TB WHERE ID = 1),
                        'YYYY-MM-DD hh24:mi:ss'),
                'yyyymmdd')
                and sxbmid='国丰车间')djwx on t1.cj=djwx.cj

