-- Katalog produktów
select * from katalog_produktow kp limit 1;

select 
	COUNT(kp.ID_Produktu_Katalog) as Li_Produktow_Katalogu
from katalog_produktow kp

select 
	COUNT(distinct kp.ID_Produktu_Katalog) as Li_Unikalnych_Prod_Kat
from katalog_produktow kp;


-- Raport kwartalny sprzedaży
select * from raport_kwartalny_sprzedaz rks limit 1;

select 
	COUNT(rks.ID_Produktu_Sprzedaz) as Li_Produktow_Sprzedazy
from raport_kwartalny_sprzedaz rks 

select 
	COUNT(distinct rks.ID_Produktu_Sprzedaz) as Li_Unikalnych_Prod_Sprz
from raport_kwartalny_sprzedaz rks 

select 
	COUNT(rks.Data_Transakcji) as Li_Dni_Transakcji
from raport_kwartalny_sprzedaz rks 

select 
	COUNT(distinct rks.Data_Transakcji) as Li_Unikalnych_Dni_Trans
from raport_kwartalny_sprzedaz rks 

select 
	rks.Data_Transakcji as Data_Transakcji
	, COUNT(rks.ID_Produktu_Sprzedaz)
from raport_kwartalny_sprzedaz rks 
group by rks.Data_Transakcji 

select 
	round(sum(rks.Wartosc_Sprzedazy), 2) as Calkowita_Wartosc_Sprzedazy
from  raport_kwartalny_sprzedaz rks 
left join katalog_produktow kp on rks.ID_Produktu_Sprzedaz = kp.ID_Produktu_Katalog 


-- 1. Liczba stransakcji z produktami spoza katalogu
select 
	count(*) as Li_transakcji_z_produktami_spoza_katalogu
from raport_kwartalny_sprzedaz rks 
left join katalog_produktow kp on rks.ID_Produktu_Sprzedaz = kp.ID_Produktu_Katalog 
where kp.ID_Produktu_Katalog is null

select count(*) from katalog_produktow kp 

select count(*) from raport_kwartalny_sprzedaz 


-- 2. Całkowita wartość sprzedaży produktów znajdująch się w katalogu
select 
	round(sum(rks.Wartosc_Sprzedazy), 2) as Calkowita_Wartosc_Sprzedazy
from  katalog_produktow kp 
left join raport_kwartalny_sprzedaz rks on rks.ID_Produktu_Sprzedaz = kp.ID_Produktu_Katalog;

-- 3a. Najwyższa różnica ceny
select 
	kp.Nazwa_Produktu as Nazwa_Produktu
	, round(avg(rks.Cena_Jednostkowa_Transakcji), 2) as Srednia_Cena_Transakcji
	, kp.Cena_Katalogowa as Cena_Katalogowa
	, round(avg(rks.Cena_Jednostkowa_Transakcji), 2) - kp.Cena_Katalogowa as Roznica_Ceny
from katalog_produktow kp 
left join raport_kwartalny_sprzedaz rks on kp.ID_Produktu_Katalog = rks.ID_Produktu_Sprzedaz 
group by 1, 3
order by Roznica_Ceny desc;

-- 3b. Różnica procentowa cen ze znakie +/-
select 
	kp.Nazwa_Produktu as Nazwa_Produktu
	, round(avg(rks.Cena_Jednostkowa_Transakcji), 2) as Srednia_Cena_Transakcji
	, kp.Cena_Katalogowa as Cena_Katalogowa
	, if (avg(rks.Cena_Jednostkowa_Transakcji) - kp.Cena_Katalogowa > 0, '+', '-') as "+/-"
	, round((avg(rks.Cena_Jednostkowa_Transakcji) / kp.Cena_Katalogowa) * 100, 2) as Roznica_Procentowa_Ceny
from katalog_produktow kp 
left join raport_kwartalny_sprzedaz rks on kp.ID_Produktu_Katalog = rks.ID_Produktu_Sprzedaz 
group by 1, 3
order by Roznica_Procentowa_Ceny desc;

-- 4. Liczba wierszy z niezgodnością
select
	count(*) as Li_Niezgodnych_Wierszy
from raport_kwartalny_sprzedaz rks 
where round(((rks.Cena_Jednostkowa_Transakcji * rks.Ilosc_Sprzedana) - rks.Wartosc_Sprzedazy), 2) > 0

-- 5. 
select 
	*
from raport_kwartalny_sprzedaz rks 