-- 1. Liczba stransakcji z produktami spoza katalogu
select 
	count(*) as Li_transakcji_z_produktami_soza_katalogu
from raport_kwartalny_sprzedaz rks 
left join katalog_produktow kp on rks.ID_Produktu_Sprzedaz = kp.ID_Produktu_Katalog 
where kp.ID_Produktu_Katalog is null

-- 2. Całkowita wartość sprzedaży produktów znajdująch się w katalogu
select 
	round(sum(rks.Wartosc_Sprzedazy), 2) as Calkowita_Wartosc_Sprzedazy
from  katalog_produktow kp 
left join raport_kwartalny_sprzedaz rks on rks.ID_Produktu_Sprzedaz = kp.ID_Produktu_Katalog;

-- 3a. Produkt o najwyższej róznicy ceny między raportem a katalogiem
select 
	kp.Nazwa_Produktu as Nazwa_Produktu
	, round(avg(rks.Cena_Jednostkowa_Transakcji), 2) as Srednia_Cena_Transakcji
	, kp.Cena_Katalogowa as Cena_Katalogowa
	, round(avg(rks.Cena_Jednostkowa_Transakcji), 2) - kp.Cena_Katalogowa as Roznica_Ceny
from katalog_produktow kp 
left join raport_kwartalny_sprzedaz rks on kp.ID_Produktu_Katalog = rks.ID_Produktu_Sprzedaz 
group by 1, 3
order by Roznica_Ceny desc
limit 1;

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
order by Roznica_Procentowa_Ceny desc
limit 1;

-- 4. Liczba wierszy z niezgodnością
select
	count(*) as Li_Niezgodnych_Wierszy
from raport_kwartalny_sprzedaz rks 
where round(((rks.Cena_Jednostkowa_Transakcji * rks.Ilosc_Sprzedana) - rks.Wartosc_Sprzedazy), 2) > 0;