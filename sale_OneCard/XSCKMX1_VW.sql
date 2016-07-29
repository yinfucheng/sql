CREATE OR REPLACE VIEW XSCKMX1_VW AS
select fid, --用于10635导出出库单和金蝶对接
       djbh,
       zdrq,
       cch,
       wldwid,
       xsfs,
       hdbz,
       mx.id,
       wlid,
       pm,
       ph,
       ggxh,
       xsjldwid,
       jldw,
       ckid,
       sfsl,
       dwcb,
       dj,
       bjdj,
       sfbdfh,
       DJZT,
       zy,
       bz
  from (select id,
               djbh,
               cch,
               zdrq,
               wldwid,
               '赊销' xsfs,
               hdbz,
               DJZT,
               bz zy,
               ckid
          from kcckd1_tb
         where djlxid = 6) zb
  left join (select id,
                    fid,
                    wlid,
                    pm,
                    ph,
                    ggxh,
                    xsjldwid,
                    case
                      when xsjldwid = jldwid then
                       '吨'
                      else
                       '包' || '(' || substr(ggxh, 1, 4) || ')'
                    end jldw, --楼上财务的要求，把规格和单位拼接在一起，以方便导入

                    0 dwcb,
                    case
                      when xsjldwid = jldwid then
                       sfsl
                      else
                       ROUND(1000 * sfsl /
                             (SELECT XS
                                FROM WLZD_TB wl
                               WHERE kcckd2_tb.wlid = wl.ID),
                             0)
                    end sfsl,
                    case
                      when xsjldwid = jldwid then
                       dj
                      else
                       0.001 * dj *
                       (select xs from wlzd_tb wl where wl.id = kcckd2_tb.wlid)
                    end dj,
                    case
                      when xsjldwid = jldwid then
                       (select bjdj
                          from xstdmx_tb
                         where xstdmx_tb.id = kcckd2_tb.xstd2id)
                      else
                       0.001 *
                       (select bjdj
                          from xstdmx_tb
                         where xstdmx_tb.id = kcckd2_tb.xstd2id) *
                       (select xs from wlzd_tb wl where wl.id = kcckd2_tb.wlid)
                    end bjdj,--可能会造成卡顿，待填坑 16-05-17
                    bz,
                    nvl(sfbdfh,0) sfbdfh
               from kcckd2_tb) mx on zb.id = mx.fid

