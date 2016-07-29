create or replace view cjscsj_vw as
with r1 as--D�߼������õ������ݼ�,��Ҫ�ظ�ʹ�ù������with as
(select sc_logdate rq, sc_loghour sj, sum(sc_etc_hour) dh
  from sc_data.sc_tempetc_tb
 where sc_pro_line = 'B'
   and instr(sc_etc_name, '����Ʒ���') <= 0
   and to_char(sc_logdate, 'yyyymmdd') > '20150901'
 group by sc_logdate, sc_loghour)

select cx,--C,D�������ݼ�

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
  from
  (select cx,
               bc,
               case
                 when sj > 8.5 and sj < 12.5 then
                  2
                 when sj > 12.5 and sj < 15.5 then
                  3
                 when sj > 16.5 and sj < 20.5 then
                  4
                 when sj > 20.5 and sj < 24 then
                  5
                 when sj > 0.5 and sj < 4.5 then
                  0
                 when sj > 4.5 and sj < 7.5 then
                  1
                 when sj = 8 and bc = '���' then
                  2
                 when sj = 8 and bc = '���' then
                  1
                 when sj = 16 and bc = '���' then
                  3
                 when sj = 16 and bc = '�а�' then
                  4
                 when sj = 0 and bc = '�а�' then
                  5
                 when sj = 0 and bc = '���' then
                  0
               end bc2,
               rq,
               case
                 when sj >= 0 and sj < 8 then
                  rq - 1
                 when sj = 8 and bc = '���' then
                  rq - 1
                 else
                  rq
               end rq2,
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
                       sc_���� bc,
                       sc_���� rq,
                       sc_Сʱ sj,
                       sc_���� b1,
                       sc_f1 f1,
                       sc_f2 f2,
                       sc_f3 f3,
                       sc_fp1 fp,
                       sc_fp2 cf,
                       sc_�ܷ� zf,
                       sc_�ܷ��� ffzl,
                       sc_��� dh
                  from sc_data.sc_Сʱ������1_tb
                union all
                select 'D' cx,
                       decode(sc_����,
                              'B�߰װ�',
                              '���',
                              'B��ҹ��',
                              '�а�',
                              '����',
                              '���') bc,
                       cl.sc_���� rq,
                       cl.sc_Сʱ sj,
                       cl.sc_���� b1,
                       cl.sc_f1 f1,
                       cl.sc_f2 f2,
                       cl.sc_f3 f3,
                       cl.sc_fp1 fp,
                       cl.sc_fp2 cf,
                       cl.sc_�ܷ� zf,
                       cl.sc_�ܷ��� ffzl,
                       decode(cl.sc_���,0,dh.dh,cl.sc_���) dh
                  from sc_data.sc_Сʱ������_tb cl
                  left join (select rq, --��ȡ��ĵ����ݼ�
                                    sj,
                                    dh,
                                    case
                                      when sj > 8 and sj < 16 then
                                       '���'
                                      when sj > 16 and sj < 24 then
                                       '�а�'
                                      when sj > 0 and sj < 8 then
                                       '���'
                                    end bc
                               from r1
                              where sj not in (0, 8, 16)
                             union all

                             select rq,
                                    sj,
                                    dh / 2 dh,
                                    case sj
                                      when 0 then
                                       '�а�'
                                      when 8 then
                                       '���'
                                      when 16 then
                                       '���'
                                    end bc
                               from r1
                              where sj in (0, 8, 16)
                             union all

                             select rq,
                                    sj,
                                    dh / 2 dh,
                                    case sj
                                      when 0 then
                                       '���'
                                      when 8 then
                                       '���'
                                      when 16 then
                                       '�а�'
                                    end bc
                               from r1
                              where sj in (0, 8, 16)) dh on cl.sc_���� =
                                                            dh.rq
                                                        and cl.sc_Сʱ =
                                                            dh.sj
                                                        and decode(cl.sc_����,
                                                                   'B�߰װ�',
                                                                   '���',
                                                                   'B��ҹ��',
                                                                   '�а�',
                                                                   '����',
                                                                   '���') =
                                                            dh.bc)
                                                            )
union all

select 'A' cx,--A�����ݼ�
       decode(t.sc_w_ban, '�װ�', '���', '�Ұ�', '�а�', '����', '���') bc,
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
       case
         when instr(t.Sc_w_Save_Time, '00:29') > 0 then
          to_char(to_date(t.sc_w_save_date, 'yyyymmdd') - 1, 'yyyymmdd')
         else
          t.sc_w_save_date
       end rq,
       case
         when t.Sc_w_Save_Time between '00:00:00' and '08:30:00' then
          to_char(to_date(t.sc_w_save_date, 'yyyymmdd') - 1, 'yyyymmdd')
         else
          t.sc_w_save_date
       end rq2,
       case
         when instr(t.Sc_w_Save_Time, '00:29') > 0 then
          '24:29:35'
         else
          t.Sc_w_Save_Time
       end sj,
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

select 'B' cx,--B�����ݼ�
       decode(t.sc_w_ban, '�װ�', '���', '�Ұ�', '�а�', '����', '���') bc,
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
       case
         when instr(t.Sc_w_Save_Time, '00:29') > 0 then
          to_char(to_date(t.sc_w_save_date, 'yyyymmdd') - 1, 'yyyymmdd')
         else
          t.sc_w_save_date
       end rq,
       case
         when t.Sc_w_Save_Time between '00:00:00' and '08:30:00' then
          to_char(to_date(t.sc_w_save_date, 'yyyymmdd') - 1, 'yyyymmdd')
         else
          t.sc_w_save_date
       end rq2,
       case
         when instr(t.Sc_w_Save_Time, '00:29') > 0 then
          '24:29:35'
         else
          t.Sc_w_Save_Time
       end sj,
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

