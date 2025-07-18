#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ТипЗнч(Параметры.ВыбранныйФайл) = Тип("Структура") Тогда
		Если Параметры.ВыбранныйФайл.Свойство("Хранение") Тогда
			ДвоичныеДанныеФайла = ПолучитьИзВременногоХранилища(Параметры.ВыбранныйФайл.Хранение);
		ИначеЕсли Параметры.ВыбранныйФайл.Свойство("ДвоичныеДанные") Тогда
			ДвоичныеДанныеФайла = Параметры.ВыбранныйФайл.ДвоичныеДанные;
		КонецЕсли;
	Иначе
		ДанныеФайла = РаботаСФайлами.ДанныеФайла(Параметры.ВыбранныйФайл);
		ДвоичныеДанныеФайла = ПолучитьИзВременногоХранилища(ДанныеФайла.СсылкаНаДвоичныеДанныеФайла);	
	КонецЕсли;
	
	ПараметрыФормыЭД = Параметры.ПараметрыФормыЭД;
	ВыбранныйФайл = Параметры.ВыбранныйФайл;
	
	Поток = ДвоичныеДанныеФайла.ОткрытьПотокДляЧтения();
	ДокументPDF.Прочитать(Поток); 
	
	ЗаполнитьДанныеДоговора();
		
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не ТипЗнч(ВыбранныйФайл) = Тип("Структура") Тогда
		Оповестить("РедактированиеФайлаЭДО",,ВыбранныйФайл);  
	КонецЕсли;

КонецПроцедуры

 
&НаКлиенте
Процедура ПриПовторномОткрытии() 
	
	Если Не ТипЗнч(ВыбранныйФайл) = Тип("Структура") Тогда
		Оповестить("РедактированиеФайлаЭДО",,ВыбранныйФайл);  
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Не ТипЗнч(ВыбранныйФайл) = Тип("Структура") Тогда
		Оповестить("ЗавершениеРедактированияФайлаЭДО",,ВыбранныйФайл);  
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_Файл" Тогда
		Если Не ЗначениеЗаполнено(Источник)
			Или (ТипЗнч(Источник) = Тип("Массив")
			И Источник.Количество() = 0) Тогда 
			Возврат;
		КонецЕсли;
		
		СсылкаНаФайл = ?(ТипЗнч(Источник) = Тип("Массив"), Источник[0], Источник);
		Если ТипЗнч(СсылкаНаФайл) <> Тип("СправочникСсылка.ДоговорыКонтрагентовПрисоединенныеФайлы") Тогда
			Возврат;
		КонецЕсли; 
		
		Событие = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметр, "Событие" , "");
		Если (Событие = "ФайлРедактировался" Или Событие = "ДанныеФайлаИзменены")
			И ТипЗнч(ВыбранныйФайл) <> Тип("Структура") И СсылкаНаФайл = ВыбранныйФайл Тогда
			ДанныеФайла = РаботаСФайламиКлиент.ДанныеФайла(СсылкаНаФайл);
			ДвоичныеДанныеФайла = ПолучитьИзВременногоХранилища(ДанныеФайла.СсылкаНаДвоичныеДанныеФайла);	
			Поток = ДвоичныеДанныеФайла.ОткрытьПотокДляЧтения();
			ДокументPDF.Прочитать(Поток); 
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Если Не ТипЗнч(ВыбранныйФайл) = Тип("Структура") Тогда
		ОсвободитьФайл();
		ОповеститьОбИзменении(ВыбранныйФайл);
		Оповестить("Запись_Файл", Новый Структура("Событие", "ДанныеФайлаИзменены"), ВыбранныйФайл);
		Оповестить("Запись_Файл", Новый Структура("Событие", "ФайлРедактировался"), ВыбранныйФайл);
	КонецЕсли;
	
	Закрыть(Истина);

КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьДанныеДоговора()
	
	Если ТипЗнч(Параметры.ПараметрыФормыЭД) = Тип("Структура") Тогда   
		Договор = Параметры.ПараметрыФормыЭД.ОбъектУчета; 
	Иначе	
		Договор = Параметры.ПараметрыФормыЭД
	КонецЕсли;
	
	Данные = Справочники.ДоговорыКонтрагентов.ПолучитьДанныеДляЭД(Договор);
	Данные.Следующий();
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	Если ЗначениеЗаполнено(Данные.Номер) Тогда
		ТекстДанных = Нстр("ru = 'Номер договорного документа: ';
							|en = 'Contractual document number: '") + Данные.Номер;
	Иначе 
		ТекстДанных = Нстр("ru = 'Номер договорного документа: без номера (б/н)';
							|en = 'Contractual document number: without number'");
	КонецЕсли;
	Если ЗначениеЗаполнено(Данные.Дата) Тогда
		ТекстДанных = ТекстДанных + " 
		|" + Нстр("ru = 'Дата договорного документа: ';
					|en = 'Contractual document date: '") + Данные.Дата;
	Иначе 
		ТекстДанных = ТекстДанных + " 
		|" + Нстр("ru = 'Дата договорного документа: без даты';
					|en = 'Contractual document date: without date'");
	КонецЕсли; 	
	ТекстДанных = ТекстДанных + " 
	|"+ Нстр("ru = 'Тип договорного документа: ';
			|en = 'Contractual document type: '") + Данные.ТипДоговора;	
	
	ТекстДанных = ТекстДанных + " 
	|" + Нстр("ru = 'Идентификационные сведения об организации:';
				|en = 'Identification information of the company:'");
	СторонаОрганизация = ЭлектронноеВзаимодействиеУТ.ПолучитьДанныеЮрФизЛица(Данные.Организация, 
		Данные.БанковскийСчет, Данные.Дата); 
		
	Если Данные.Организация_ЮрФизЛицо = Перечисления.ЮрФизЛицо.ИндивидуальныйПредприниматель Тогда
		ТекстДанных = ТекстДанных + " 
		|" + Нстр("ru = 'o Сведения об индивидуальном предпринимателе:';
					|en = 'o Information on the individual entrepreneur:'");

		ТекстДанных = ТекстДанных + " 
		|" + Нстр("ru = '  •	Краткое название: ';
					|en = '  •	Short name: '") + СторонаОрганизация.СокращенноеНаименование;
		Если ЗначениеЗаполнено(СторонаОрганизация.КодПоОКПО) Тогда
			ТекстДанных = ТекстДанных + " 
			|" + Нстр("ru = '  •	Код по ОКПО: ';
						|en = '  •	OKPO code: '") + СторонаОрганизация.КодПоОКПО;
		КонецЕсли; 
		ТекстДанных = ТекстДанных + " 
		|" + Нстр("ru = '  •	ИНН: ';
					|en = '  •	TIN: '") + СторонаОрганизация.ИНН; 
		ТекстДанных = ТекстДанных + " 
		|" + Нстр("ru = '  •	ОГРН ИП: ';
					|en = '  •	OGRN of the individual entrepreneur: '") + СторонаОрганизация.ОГРН;
		ТекстДанных = ТекстДанных + " 
		|" + Нстр("ru = '  •	Фамилия: ';
					|en = '  •	Last name: '") + СторонаОрганизация.Фамилия;
		ТекстДанных = ТекстДанных + " 
		|" + Нстр("ru = '  •	Имя: ';
					|en = '  •	Name: '") + СторонаОрганизация.Имя; 
		Если ЗначениеЗаполнено(СторонаОрганизация.Отчество) Тогда
			ТекстДанных = ТекстДанных + " 
			|" + Нстр("ru = '  •	Отчество: ';
						|en = '  •	Middle name: '") + СторонаОрганизация.Отчество;
		КонецЕсли;
	ИначеЕсли Данные.Организация_ЮрФизЛицо = Перечисления.ЮрФизЛицо.ЮрЛицо Тогда
		ТекстДанных = ТекстДанных + " 
		|" + Нстр("ru = 'o Сведения об юридическом лице:';
					|en = 'o Information on the legal entity:'");

		ТекстДанных = ТекстДанных + " 
		|" + Нстр("ru = '  •	Краткое название: ';
					|en = '  •	Short name: '") + СторонаОрганизация.СокращенноеНаименование;
		Если ЗначениеЗаполнено(СторонаОрганизация.КодПоОКПО) Тогда
			ТекстДанных = ТекстДанных + " 
			|" + Нстр("ru = 'Код по ОКПО: ';
						|en = 'OKPO code: '") + СторонаОрганизация.КодПоОКПО;
		КонецЕсли; 
		ТекстДанных = ТекстДанных + " 
		|" + Нстр("ru = '  •	Наименование полное: ';
					|en = '  •	Full name: '") + СторонаОрганизация.ПолноеНаименование;
		ТекстДанных = ТекстДанных + " 
		|" + Нстр("ru = '  •	ИНН: ';
					|en = '  •	TIN: '") + СторонаОрганизация.ИНН;
		Если ЗначениеЗаполнено(СторонаОрганизация.ОГРН) Тогда
			ТекстДанных = ТекстДанных + " 
			|" + Нстр("ru = '  •	ОГРН: ';
						|en = '  •	OGRN: '") + СторонаОрганизация.ОГРН;
		КонецЕсли;  
		Если ЗначениеЗаполнено(СторонаОрганизация.КПП) Тогда
			ТекстДанных = ТекстДанных + " 
			|" + Нстр("ru = '  •	КПП: ';
						|en = '  •	KPP: '") + СторонаОрганизация.КПП;
		КонецЕсли; 
	КонецЕсли;

	Обработка = Обработки.ФорматДоговорныйДокумент101.Создать();

	ТекстДанных = ТекстДанных + " 
	|" + Нстр("ru = 'o Адрес организации:';
				|en = 'o Company address:'"); 
	Адрес = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(
			Данные.Организация, 
			ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации), 
			Данные.Дата, Ложь);	
			
	АдресЗначение = "";
	Если ЗначениеЗаполнено(Адрес) Тогда
		АдресЗначение = Адрес[0].Представление;
	КонецЕсли;		
	ТекстДанных = ТекстДанных + " 
	|" + Нстр("ru = '  •	';
				|en = '  •	'") + АдресЗначение;
	
	Если ЗначениеЗаполнено(СторонаОрганизация.Телефоны) ИЛИ ЗначениеЗаполнено(СторонаОрганизация.ЭлектроннаяПочта) Тогда
		ТекстДанных = ТекстДанных + " 
		|" + Нстр("ru = 'o Контактные данные организации:';
					|en = 'o Company contact information:'"); 
		Если ЗначениеЗаполнено(СторонаОрганизация.Телефоны) Тогда
			ТекстДанных = ТекстДанных + " 
			|" + Нстр("ru = '  •	Телефон: ';
						|en = '  •	Phone number: '") + СторонаОрганизация.Телефоны;
		КонецЕсли;  
		Если ЗначениеЗаполнено(СторонаОрганизация.ЭлектроннаяПочта) Тогда
			ТекстДанных = ТекстДанных + " 
			|" + Нстр("ru = '  •	Электронная почта: ';
						|en = '  •	 Email: '") + СторонаОрганизация.ЭлектроннаяПочта;
		КонецЕсли; 
	КонецЕсли;
		
	ТекстДанных = ТекстДанных + " 
	|" + Нстр("ru = 'o Банковские реквизиты организации:';
				|en = 'o Company bank details:'");
	Если ЗначениеЗаполнено(Данные.Организация_БанковскийСчет_ИНН) Тогда
		ТекстДанных = ТекстДанных + " 
		|" + Нстр("ru = '  •	ИНН банка: ';
					|en = '  •	Bank TIN: '") + Данные.Организация_БанковскийСчет_ИНН;
	КонецЕсли;
	ТекстДанных = ТекстДанных + " 
	|" + Нстр("ru = '  •	Расчетный счет: ';
				|en = '  •	Account: '") + Данные.Организация_БанковскийСчет_НомерСчета;
	Если ЗначениеЗаполнено(Данные.Организация_БанковскийСчет_НаименованиеБанка) Тогда
		ТекстДанных = ТекстДанных + " 
		|" + Нстр("ru = '  •	Наименование банка: ';
					|en = '  •	Bank name: '") + Данные.Организация_БанковскийСчет_НаименованиеБанка;
	КонецЕсли;
	ТекстДанных = ТекстДанных + " 
	|" + Нстр("ru = '  •	БИК банка: ';
				|en = '  •	Bank BIC: '") + Данные.Организация_БанковскийСчет_БИК;
	ТекстДанных = ТекстДанных + " 
	|" + Нстр("ru = '  •	Корреспондентский счет: ';
				|en = '  •	Correspondent account: '") + Данные.Организация_БанковскийСчет_КоррСчет;
	
	ТекстДанных = ТекстДанных + " 
	|" + Нстр("ru = 'Идентификационные сведения о контрагенте:';
				|en = 'Identification information of the counterparty:'");
	СторонаКонтрагент = ЭлектронноеВзаимодействиеУТ.ПолучитьДанныеЮрФизЛица(Данные.Контрагент, 
		Данные.БанковскийСчетКонтрагента, Данные.Дата);
		
	Если Данные.Контрагент_ЮрФизЛицо = Перечисления.ЮрФизЛицо.ИндивидуальныйПредприниматель Тогда		
		ТекстДанных = ТекстДанных + " 
		|" + Нстр("ru = 'o Сведения об индивидуальном предпринимателе:';
					|en = 'o Information on the individual entrepreneur:'");

		ТекстДанных = ТекстДанных + " 
		|" + Нстр("ru = '  •	Краткое название: ';
					|en = '  •	Short name: '") + СторонаКонтрагент.СокращенноеНаименование;		
		Если ЗначениеЗаполнено(СторонаКонтрагент.КодПоОКПО) Тогда
			ТекстДанных = ТекстДанных + " 
			|" + Нстр("ru = '  •	Код по ОКПО: ';
						|en = '  •	OKPO code: '") + СторонаКонтрагент.КодПоОКПО;
		КонецЕсли; 
		ТекстДанных = ТекстДанных + " 
		|" + Нстр("ru = '  •	ИНН: ';
					|en = '  •	TIN: '") + СторонаКонтрагент.ИНН; 
		ТекстДанных = ТекстДанных + " 
		|" + Нстр("ru = '  •	ОГРН ИП: ';
					|en = '  •	OGRN of the individual entrepreneur: '") + СторонаКонтрагент.ОГРН;
		ТекстДанных = ТекстДанных + " 
		|" + Нстр("ru = '  •	Фамилия: ';
					|en = '  •	Last name: '") + СторонаКонтрагент.Фамилия;
		ТекстДанных = ТекстДанных + " 
		|" + Нстр("ru = '  •	Имя: ';
					|en = '  •	Name: '") + СторонаКонтрагент.Имя; 
		Если ЗначениеЗаполнено(СторонаКонтрагент.Отчество) Тогда
			ТекстДанных = ТекстДанных + " 
			|" + Нстр("ru = '  •	Отчество: ';
						|en = '  •	Middle name: '") + СторонаКонтрагент.Отчество;
		КонецЕсли;
	ИначеЕсли Данные.Контрагент_ЮрФизЛицо = Перечисления.ЮрФизЛицо.ЮрЛицо Тогда
		ТекстДанных = ТекстДанных + " 
		|" + Нстр("ru = 'o Сведения об юридическом лице:';
					|en = 'o Information on the legal entity:'");	

		ТекстДанных = ТекстДанных + " 
		|" + Нстр("ru = '  •	Краткое название: ';
					|en = '  •	Short name: '") + СторонаКонтрагент.СокращенноеНаименование;		
		Если ЗначениеЗаполнено(СторонаКонтрагент.КодПоОКПО) Тогда
			ТекстДанных = ТекстДанных + " 
			|" + Нстр("ru = 'Код по ОКПО: ';
						|en = 'OKPO code: '") + СторонаКонтрагент.КодПоОКПО;
		КонецЕсли; 
		ТекстДанных = ТекстДанных + " 
		|" + Нстр("ru = '  •	Наименование полное: ';
					|en = '  •	Full name: '") + СторонаКонтрагент.ПолноеНаименование;
		ТекстДанных = ТекстДанных + " 
		|" + Нстр("ru = '  •	ИНН: ';
					|en = '  •	TIN: '") + СторонаКонтрагент.ИНН;
		Если ЗначениеЗаполнено(СторонаКонтрагент.ОГРН) Тогда
			ТекстДанных = ТекстДанных + " 
			|" + Нстр("ru = '  •	ОГРН: ';
						|en = '  •	OGRN: '") + СторонаКонтрагент.ОГРН;
		КонецЕсли;  
		Если ЗначениеЗаполнено(СторонаКонтрагент.КПП) Тогда
			ТекстДанных = ТекстДанных + " 
			|" + Нстр("ru = '  •	КПП: ';
						|en = '  •	KPP: '") + СторонаКонтрагент.КПП;
		КонецЕсли; 
	ИначеЕсли Данные.Контрагент_ЮрФизЛицо = Перечисления.ЮрФизЛицо.ЮрЛицоНеРезидент Тогда
		ТекстДанных = ТекстДанных + " 
		|" + Нстр("ru = '  •	Наименование полное: ';
					|en = '  •	Full name: '") + СторонаКонтрагент.ПолноеНаименование;
		КодСтраны = Обработка.ЗаполнитьКодСтраныИностранногоАдреса(Справочники.ВидыКонтактнойИнформации.ЮрАдресКонтрагента,
				Данные.Контрагент, Данные.Дата, Обработка);
		ТекстДанных = ТекстДанных + " 
		|" + Нстр("ru = '  •	Код страны: ';
					|en = '  •	Country code: '") + КодСтраны;
		ТекстДанных = ТекстДанных + " 
		|" + Нстр("ru = '  •	Регистрационный номер: ';
					|en = '  •	Registration number: '") + Данные.Контрагент_ИдентификаторЮридическогоЛица;
	ИначеЕсли Данные.Контрагент_ЮрФизЛицо = Перечисления.ЮрФизЛицо.ФизЛицо Тогда
		ТекстДанных = ТекстДанных + " 
		|" + Нстр("ru = '  •	ИНН: ';
					|en = '  •	TIN: '") + СторонаКонтрагент.ИНН;
		ТекстДанных = ТекстДанных + " 
		|" + Нстр("ru = '  •	Фамилия: ';
					|en = '  •	Last name: '") + СторонаКонтрагент.Фамилия;
		ТекстДанных = ТекстДанных + " 
		|" + Нстр("ru = '  •	Имя: ';
					|en = '  •	Name: '") + СторонаКонтрагент.Имя; 
		Если ЗначениеЗаполнено(СторонаКонтрагент.Отчество) Тогда
			ТекстДанных = ТекстДанных + " 
			|" + Нстр("ru = '  •	Отчество: ';
						|en = '  •	Middle name: '") + СторонаКонтрагент.Отчество;
		КонецЕсли;
	КонецЕсли;

	ТекстДанных = ТекстДанных + " 
	|" + Нстр("ru = 'o Адрес контрагента:';
				|en = 'o Counterparty address:'"); 
	Адрес = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(
			Данные.Контрагент, 
			ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Справочники.ВидыКонтактнойИнформации.ЮрАдресКонтрагента), 
			Данные.Дата, Ложь);	
			
	АдресЗначение = "";
	Если ЗначениеЗаполнено(Адрес) Тогда
		АдресЗначение = Адрес[0].Представление;
	КонецЕсли;		
	ТекстДанных = ТекстДанных + " 
	|" + Нстр("ru = '  •	';
				|en = '  •	'") + АдресЗначение;	
		
	Если ЗначениеЗаполнено(СторонаКонтрагент.Телефоны) ИЛИ ЗначениеЗаполнено(СторонаКонтрагент.ЭлектроннаяПочта) Тогда
		ТекстДанных = ТекстДанных + " 
		|" + Нстр("ru = 'o Контактные данные контрагента:';
					|en = 'o Counterparty contact information:'"); 
		Если ЗначениеЗаполнено(СторонаКонтрагент.Телефоны) Тогда
			ТекстДанных = ТекстДанных + " 
			|" + Нстр("ru = '  •	Телефон: ';
						|en = '  •	Phone number: '") + СторонаКонтрагент.Телефоны;
		КонецЕсли;  
		Если ЗначениеЗаполнено(СторонаКонтрагент.ЭлектроннаяПочта) Тогда
			ТекстДанных = ТекстДанных + " 
			|" + Нстр("ru = '  •	Электронная почта: ';
						|en = '  •	 Email: '") + СторонаКонтрагент.ЭлектроннаяПочта;
		КонецЕсли; 
	КонецЕсли;
		
	ТекстДанных = ТекстДанных + " 
	|" + Нстр("ru = 'o Банковские реквизиты организации:';
				|en = 'o Company bank details:'");
	Если ЗначениеЗаполнено(Данные.Контрагент_БанковскийСчет_ИНН) Тогда
		ТекстДанных = ТекстДанных + " 
		|" + Нстр("ru = '  •	ИНН банка: ';
					|en = '  •	Bank TIN: '") + Данные.Контрагент_БанковскийСчет_ИНН;
	КонецЕсли;
	ТекстДанных = ТекстДанных + " 
	|" + Нстр("ru = '  •	Расчетный счет: ';
				|en = '  •	Account: '") + Данные.Контрагент_БанковскийСчет_НомерСчета;
	Если ЗначениеЗаполнено(Данные.Контрагент_БанковскийСчет_НаименованиеБанка) Тогда
		ТекстДанных = ТекстДанных + " 
		|" + Нстр("ru = '  •	Наименование банка: ';
					|en = '  •	Bank name: '") + Данные.Контрагент_БанковскийСчет_НаименованиеБанка;
	КонецЕсли;
	ТекстДанных = ТекстДанных + " 
	|" + Нстр("ru = '  •	БИК банка: ';
				|en = '  •	Bank BIC: '") + Данные.Контрагент_БанковскийСчет_БИК;
	ТекстДанных = ТекстДанных + " 
	|" + Нстр("ru = '  •	Корреспондентский счет: ';
				|en = '  •	Correspondent account: '") + Данные.Контрагент_БанковскийСчет_КоррСчет;	
	
	ТекстДанных = ТекстДанных + " 
		|" + Нстр("ru = 'Сумма договора: ';
					|en = 'Contract amount: '") + Данные.Сумма;
	Если ЗначениеЗаполнено(Данные.Валюта_Наименование) Тогда
		ТекстДанных = ТекстДанных + " 
		|" + Нстр("ru = 'Валюта: ';
					|en = 'Currency: '") + Данные.Валюта_Наименование;
	КонецЕсли;	
	Если ЗначениеЗаполнено(Данные.ПорядокРасчетов) Тогда
		ТекстДанных = ТекстДанных + " 
		|" + Нстр("ru = 'Детализация расчетов: ';
					|en = 'Define AR/AP as: '") + Данные.ПорядокРасчетов;
	КонецЕсли;  
	Если ЗначениеЗаполнено(Данные.СрокОплаты) Тогда 
		ТекстДанных = ТекстДанных + " 
		|" + Нстр("ru = 'Срок оплаты: долгосрочная (больше 365 дней)';
					|en = 'Payment due date: long-term (over 365 days)'");
	Иначе
		ТекстДанных = ТекстДанных + " 
		|" + Нстр("ru = 'Срок оплаты: краткосрочная ';
					|en = 'Payment due date: short-term'");
	КонецЕсли;
	Если ЗначениеЗаполнено(Данные.ДатаНачалаДействия) Тогда
		ТекстДанных = ТекстДанных + " 
		|" + Нстр("ru = 'Дата начала действия: ';
					|en = 'Effective date:'") + Данные.ДатаНачалаДействия;
	КонецЕсли;
	Если ЗначениеЗаполнено(Данные.ДатаНачалаДействия) Тогда
		ТекстДанных = ТекстДанных + " 
		|" + Нстр("ru = 'Дата окончания действия: ';
					|en = 'Expiration date:'") + Данные.ДатаОкончанияДействия;
	КонецЕсли;
	
	ДанныеДоговора = ТекстДанных;
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами

КонецПроцедуры

&НаСервере
Процедура ОсвободитьФайл()
	
	Если ЗначениеЗаполнено(ВыбранныйФайл.Редактирует) 
		И ВыбранныйФайл.Редактирует = Пользователи.ТекущийПользователь() Тогда 
		НачатьТранзакцию();
		Попытка
			БлокировкаДанных = Новый БлокировкаДанных;
			ЭлементБлокировкиДанных = БлокировкаДанных.Добавить(Метаданные.НайтиПоТипу(ТипЗнч(ВыбранныйФайл)).ПолноеИмя());
			ЭлементБлокировкиДанных.УстановитьЗначение("Ссылка", ВыбранныйФайл);
			БлокировкаДанных.Заблокировать();
			
			ФайлОбъект = ВыбранныйФайл.Ссылка.ПолучитьОбъект();
			
			ЗаблокироватьДанныеДляРедактирования(ФайлОбъект.Ссылка, , УникальныйИдентификатор);
			ФайлОбъект.Редактирует = Справочники.Пользователи.ПустаяСсылка();
			ФайлОбъект.ДатаЗаема = Дата("00010101000000");
			ФайлОбъект.Записать();
			
			РаботаСФайламиПереопределяемый.ПриОсвобожденииФайла(ВыбранныйФайл, УникальныйИдентификатор);
			РазблокироватьДанныеДляРедактирования(ВыбранныйФайл, УникальныйИдентификатор);
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			РазблокироватьДанныеДляРедактирования(ВыбранныйФайл, УникальныйИдентификатор);
			ВызватьИсключение;
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти