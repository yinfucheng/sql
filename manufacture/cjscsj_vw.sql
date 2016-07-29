create or replace view cjscsj_vw as
select cx, --C,D线总数据集

       bc,
       bc2,
       null datetime,
       to_char(rq, 'yyyymmdd') rq,
       to_char(rq2, 'yyyymmdd') rq2,
       to_char(sj) sj,
       null sj2,
       b1,
       f1,
       f2,
       f3,
       fp cfp,
       0 xfp,
       cf,
       zf,
       ffzl,
       null zcfl,
       0 mjdh,
       0 fjdh,
       0 mfjdh,
       0 gyjdh,
       0 kyjdh,
       dh zdh,
       null dfdh,
       null yxgs
  from (select cx,
               case when to_char(rq,'yyyymmdd')<='20160302' then bc else decode(bc,'夜班','中班','丁班','晚班',bc) end  bc,
               case
                 when sj > 7.5 and sj < 11.5 then
                  2
                 when sj > 11.5 and sj < 15.5 then
                  3
                 when sj > 15.5 and sj < 19.5 then
                  4
                 when sj > 19.5 and sj < 23.5 then
                  5
                 when sj >=0  and sj < 3.5 then
                  0
                 when sj > 3.5 and sj < 7.5 then
                  1

               end bc2,
               rq,

               rq rq2,
               sj,
               b1,
               f1,
               f2,
               f3,
               fp,
               cf,
               zf,
               ffzl,
               dh
          from (select 'C' cx,
                       sc_班组 bc,
                       sc_日期 rq,
                       sc_小时 sj,
                       sc_净麦 b1,
                       sc_f1 f1,
                       sc_f2 f2,
                       sc_f3 f3,
                       sc_fp1 fp,
                       sc_fp2 cf,
                       sc_总粉 zf,
                       sc_总粉麸 ffzl,
                       sc_电耗 dh
                  from sc_data.sc_小时产量表1_tb
                  where not (sc_班组='丁班' and sc_小时=23)

                union all
                select 'D' cx,
                       sc_班组 bc,
                       sc_日期 rq,
                       sc_小时 sj,
                       sc_净麦 b1,
                       sc_f1 f1,
                       sc_f2 f2,
                       sc_f3 f3,
                       sc_fp1 fp,
                       sc_fp2 cf,
                       sc_总粉 zf,
                       sc_总粉麸 ffzl,
                       sc_电耗 dh
                  from sc_data.sc_小时产量表_tb
                  where not (sc_班组='丁班' and sc_小时=23)



                )
                where to_char(rq,'yyyymmdd') >'20150901'
                )
union all

select 'A' cx, --A线数据集
       decode(t.sc_w_ban, '甲班', '早班', '乙班', '中班', '丙班', '晚班') bc,
       case
         when t.Sc_w_Save_Time between '00:30' and '04:30' then
          0
         when t.Sc_w_Save_Time between '04:30' and '08:30' then
          1
         when t.Sc_w_Save_Time between '08:30' and '12:30' then
          2
         when t.Sc_w_Save_Time between '12:30' and '16:30' then
          3
         when t.Sc_w_Save_Time between '16:30' and '20:30' then
          4
         when t.Sc_w_Save_Time between '20:30' and '24:00' then
          5
         when t.Sc_w_Save_Time between '00:00' and '00:30' then
          5
       end bc2,
       t.sc_w_save_datetime datetime,
       t.sc_w_save_date rq,
       case
         when t.Sc_w_Save_Time between '00:00:00' and '08:30:00' then
          to_char(to_date(t.sc_w_save_date, 'yyyymmdd') - 1, 'yyyymmdd')
         else
          t.sc_w_save_date
       end rq2,

       t.Sc_w_Save_Time sj,
       case
         when instr(t.Sc_w_Save_Time, '00:29') > 0 then
          '24:29'
         else
          substr(t.Sc_w_Save_Time, 0, 5)
       end sj2,
       t.sc_w_j1wei b1,
       t.sc_w_f1wei f1,
       t.sc_w_f2wei f2,
       t.sc_w_f3wei f3,
       t.sc_w_fp1wei cfp,
       t.sc_w_fp2wei xfp,
       t.sc_w_cf1wei cf,
       t.sc_w_z_fenwei zf,
       t.sc_w_z_fenfuwei ffzl,
       t.sc_w_z_fenper zcfl,
       t.sc_w_z_amj mjdh,
       t.sc_w_z_afj fjdh,
       t.sc_w_z_amf mfjdh,
       t.sc_w_z_gy gyjdh,
       t.sc_w_z_ky kyjdh,
       t.sc_w_z_dh_all zdh,
       t.sc_w_z_df dfdh,
       t.sc_w_z_gs yxgs
  from sc_data.sc_wdl_hourdate_save_tb t
 where t.sc_w_save_date > '20150901'
union all

select 'B' cx, --B线数据集
       decode(t.sc_w_ban, '甲班', '早班', '乙班', '中班', '丙班', '晚班') bc,
       case
         when t.Sc_w_Save_Time between '00:30' and '04:30' then
          0
         when t.Sc_w_Save_Time between '04:30' and '08:30' then
          1
         when t.Sc_w_Save_Time between '08:30' and '12:30' then
          2
         when t.Sc_w_Save_Time between '12:30' and '16:30' then
          3
         when t.Sc_w_Save_Time between '16:30' and '20:30' then
          4
         when t.Sc_w_Save_Time between '20:30' and '24:00' then
          5
         when t.Sc_w_Save_Time between '00:00' and '00:30' then
          5
       end bc2,
       t.sc_w_save_datetime datetime,
       t.sc_w_save_date rq,
       case
         when t.Sc_w_Save_Time between '00:00:00' and '08:30:00' then
          to_char(to_date(t.sc_w_save_date, 'yyyymmdd') - 1, 'yyyymmdd')
         else
          t.sc_w_save_date
       end rq2,

       t.Sc_w_Save_Time sj,
    case
         when instr(t.Sc_w_Save_Time, '00:29') > 0 then
          '24:29'
         else
          substr(t.Sc_w_Save_Time, 0, 5)
       end sj2,
       t.sc_w_j2wei b1,
       t.sc_w_f4wei f1,
       t.sc_w_f5wei f2,
       t.sc_w_f6wei f3,
       t.sc_w_fp3wei cfp,
       t.sc_w_fp4wei xfp,
       t.sc_w_cf2wei cf,
       t.sc_w_z_bfenwei zf,
       t.sc_w_z_bfenfuwei ffzl,
       t.sc_w_z_bfenper zcfl,
       t.sc_w_z_bmj mjdh,
       t.sc_w_z_bfj fjdh,
       t.sc_w_z_bmf mfjdh,
       t.sc_w_z_bgy gyjdh,
       0 kyjdh,
       t.sc_w_z_dh_ball zdh,
       t.sc_w_z_bdf dfdh,
       t.sc_w_z_bgs yxgs
  from sc_data.sc_wdl_hourdate_save_tb t
 where t.sc_w_save_date > '20150901'

