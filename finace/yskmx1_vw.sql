create or replace view yskmx1_vw as
(select wldwid,null djbh,'期初小计' djlx,null djzt,p_view_param.get_KSRQ() ywrq,null ph,null pm,null sl,null dj,null je,sum(ysje) ysje,sum(skje)skje,null he,null bz,sum(qmje)qmje from
(select wldwid,
        fpje YSJE,
        0 SKJE,
       -fpje QMJE
  from xsfp1_tb zb
 where zdrq <p_view_param.get_KSRQ() and djzt=1

union all
select wldwid, 0 YSJE,SKJE,skje QMJE
  from xshk_tb
 where ywrq < p_view_param.get_KSRQ() and djzt=1
)
 group by wldwid
 union all

  select wldwid,djbh,nvl(djlx,'合计')djlx,djzt,ywrq,ph,pm,sl,dj,je,sum(ysje)ysje,sum(skje)skje,he,bz,qmye qmje  from
(select wldwid,djbh,djlx,djzt,ywrq,ph,pm,sl,dj,je,ysje,skje,he,bz,sum(he)over (PARTITION BY wldwid ORDER BY wldwid ASC, YWRQ ASC, DJBH ASC)QMYE from
((select wldwid,djbh,'销售发票' djlx,djzt,ywrq,null ph,
       null pm,

       null sl,
       null dj,
       null je,ysje,0 skje,-ysje he,bz from
(select id,
       wldwid,
       djbh,
       djzt,
       zb.zdrq ywrq,

       fpje ysje,
       bz
  from xsfp1_tb zb where djzt=1)
  union all
select wldwid,djbh,'收款单据' djlx,djzt,ywrq,null ph,
       null pm,

       null sl,
       null dj,
       null je,0 ysje,skje,skje he,bz from xshk_tb where djzt=1 )
 union all
 select wldwid,
       djbh,
       '发票明细' djlx,
       djzt,
       t1.zdrq ywrq,
       ph,
       pm,

       sl,
       hsdj,
       sl * hsdj je ,0 ysje,
       0 skje,
       0 he,
       t2.bz  from xsfp2_tb t2
  left join xsfp1_tb t1 on t1.id = t2.xsfp1id where t1.djzt=1

       ) )
WHERE YWRQ BETWEEN p_view_param.get_KSRQ() and p_view_param.get_JSRQ()+1

 group by grouping sets((wldwid),(wldwid,djbh,djlx,djzt,ywrq,ph,pm,sl,dj,je,he,bz,qmye))
 )
 --T left join wldw_tb wldw where t.wldwid = wldw.id

