create or replace function xstdmx_wc_fc(p_id in number)
return number
is
p_wc number :=0 ;
p_dlh varchar2(50);
p_factor number;
cursor xstdmx_cursor is select id,ph,1000*sl sl,wlid from xstdmx_tb where fid=p_id;
begin
for cv_xstdmx in xstdmx_cursor
loop
select ph  into p_dlh from wlzd_tb  where id=(select fid from wlzd_tb where id=cv_xstdmx.wlid) ;
if p_dlh='01.12' then
select wc/20/xs into p_factor from gbwc_tb where id=2;
p_wc :=p_wc+cv_xstdmx.sl*p_factor;
elsif p_dlh='01.13' then
select wc/20/xs into p_factor from gbwc_tb where id=2;
p_wc :=p_wc+cv_xstdmx.sl*p_factor;
else
select wc/20/xs into p_factor from gbwc_tb where id=1;
p_wc :=p_wc+cv_xstdmx.sl*p_factor;
end if;

end loop;

return p_wc;

end xstdmx_wc_fc;
