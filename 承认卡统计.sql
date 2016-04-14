--合计所有有效成人卡不含月票1039794
select count(*)
  from TF_F_CARDREC t
 where t.selltime >= to_date('20020101', 'yyyyMMdd')
   and t.selltime <= to_date('20151231', 'yyyyMMdd')
   and not exists (select *
          from TF_F_CARDUSEAREA b
         where b.cardno = t.cardno
           and b.usetag = '1')
   and t.usetag = '1';
   
--合计所有有效活跃成人卡不含月票张数509852
select count(*)
  from TF_F_CARDREC t, TF_F_CARDEWALLETACC c
 where t.selltime >= to_date('20020101', 'yyyyMMdd')
   and t.selltime <= to_date('20151231', 'yyyyMMdd')
   and not exists
 (select *
          from TF_F_CARDUSEAREA b
         where b.cardno = t.cardno
           and b.usetag = '1')
   and t.usetag = '1'
   and t.cardno = c.cardno
   and c.lastconsumetime > to_date('20160101', 'yyyyMMdd');
   
   
   
   
   
--活跃人群中没申领过市民卡人数
select c.cardno, d.custname, d.paperno, d.custphone
  from TF_F_CARDREC t, TF_F_CARDEWALLETACC c, tf_f_customerrec d
 where t.selltime >= to_date('20020101', 'yyyyMMdd')
   and t.selltime <= to_date('20151231', 'yyyyMMdd')
   and not exists (select *
          from TF_F_CARDUSEAREA b
         where b.cardno = t.cardno
           and b.usetag = '1')
   and t.usetag = '1'
   and t.cardno = c.cardno
   and c.lastconsumetime > to_date('20160101', 'yyyyMMdd')
   and c.cardno = d.cardno
   and not exists
 (select * from tf_f_residentcard e where e.paperno = d.paperno);









select count(distinct m.paperno)--, m.custname,m.custphone
  from (select a.cardno
          from (select t.cardno
                  from TF_F_CARDREC t
                 where to_char(t.selltime, 'yyyy') >= '2006'
                   and to_char(t.selltime, 'yyyy') <= '2006'
                   and t.usetag = '1') c,
               TF_F_CARDEWALLETACC a
         where c.cardno = a.cardno
           and to_char(a.Lastconsumetime, 'yyyymmdd') >= '20160101'
           and a.usetag = '1') q,
       TF_F_RESIDENTCARD n,
       TF_F_CUSTOMERREC m
 where q.cardno = m.cardno
   and m.usetag = '1'
   and q.cardno not in
       (select w.cardno
          from (select a.cardno
                  from (select t.cardno
                          from TF_F_CARDREC t
                         where to_char(t.selltime, 'yyyy') >= '2002'
                           and to_char(t.selltime, 'yyyy') <= '2005'
                           and t.usetag = '1') c,
                       TF_F_CARDEWALLETACC a
                 where c.cardno = a.cardno
                   and to_char(a.Lastconsumetime, 'yyyymmdd') >= '20160101'
                   and a.usetag = '1') q,
               TF_F_RESIDENTCARD w
         where q.cardno = w.cardno)
