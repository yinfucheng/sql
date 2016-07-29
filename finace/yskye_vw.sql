create or replace view yskye_vw as
select ye.qkje,
       ye.wldwid id,
       wldw.dwmc,
       wldw.dwjc,
       wldw.qkqx,
       WLDW.ZJM,
       case
         when ye.qkje < 0 then
          -1
         else
          1
       end cxlb,
       ye.qkje + nvl(qkqx.fpje,0) cqqk,
       kbye.qkje qkje1

  from (select sum(skje) qkje, wldwid
          from (select -skje skje, wldwid
                  from xshk_tb
                 where djzt = 1
                union all
                select fpje skje, wldwid from xsfp1_tb where djzt = 1)
         group by wldwid) ye
  --第一个left join之前为计算当前欠款金额的数据集
  left join wldw_tb wldw on ye.wldwid = wldw.id--获得一些客户信息
  left join (select sum(skje) qkje, wldwid
               from (select -skje skje, wldwid
                       from xshk_tb
                      where djzt = 1
                        and ywrq <=
                            to_date((select jssj from cjcs_tb where id = 2),
                                    'YYYY-MM-DD HH24:MI:SS')
                       --借用车间参数表传参，在相应pu中通过“新查询”按钮更新参数值
                     union all
                     select fpje skje, wldwid
                       from xsfp1_tb
                      where djzt = 1
                        and ywrq <=
                            to_date((select jssj from cjcs_tb where id = 2),
                                    'YYYY-MM-DD HH24:MI:SS'))
              group by wldwid) kbye on ye.wldwid = kbye.wldwid--根据时间变动的欠款金额计算数据集
  left join (select sum(-fpje)fpje,t1.wldwid
                       from xsfp1_tb t1 left join wldw_tb t2 on t1.wldwid=t2.id
                      where t1.djzt = 1
                        and t1.ywrq >= sysdate - nvl(t2.qkqx, 0) group by t1.wldwid
                       ) qkqx on qkqx.wldwid=ye.wldwid
   WHERE kbye.qkje<>0

