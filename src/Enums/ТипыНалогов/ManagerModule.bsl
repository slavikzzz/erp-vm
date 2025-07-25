#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

//++ Локализация

// Возвращает КБК с учетом вида налогового обязательства
//
// Параметры:
//   ТипНалога                  - ПеречислениеСсылка.ТипыНалогов
//   ВидНалоговогоОбязательства - ПеречислениеСсылка.ВидыПлатежейВГосБюджет
//   Период                     - Дата
//
// Возвращаемое значение:
//   Строка
//
Функция КБКПоВидуНалоговогоОбязательства(ТипНалога, Знач ВидНалоговогоОбязательства = Неопределено, Знач Период = Неопределено) Экспорт
	
	КБК = КБКПоТипуНалога(ТипНалога);
	Если ПустаяСтрока(КБК) Тогда
		Возврат "";
	КонецЕсли;
	
	//++ НЕ УТ
	
	Если Не ЗначениеЗаполнено(ВидНалоговогоОбязательства) Тогда
		Если ПлатежиВБюджетКлиентСервер.КодПодвидаДоходов(КБК) <> ПлатежиВБюджетКлиентСервер.ПустойКодПодвидаДоходов() Тогда
			Возврат КБК; // Сохраняем заданный код подвида доходов
		Иначе
			ВидНалоговогоОбязательства = Перечисления.ВидыПлатежейВГосБюджет.Налог;
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Период) Тогда
		Период = ТекущаяДатаСеанса();
	КонецЕсли;
	
	КодГлавногоАдминистратора    = ПлатежиВБюджетКлиентСервер.КодГлавногоАдминистратора(КБК);
	КодВидаДоходов               = ПлатежиВБюджетКлиентСервер.КодВидаДоходов(КБК);
	КодПодвидаДоходов            = КодПодвидаДоходов(КБК, ТипНалога, ВидНалоговогоОбязательства, Период);
	КодОперацииСектораУправления = ПлатежиВБюджетКлиентСервер.КодОперацииСектораУправления(КБК);
	
	КБК = КодГлавногоАдминистратора + КодВидаДоходов + КодПодвидаДоходов + КодОперацииСектораУправления;
	
	//-- НЕ УТ
	
	Возврат КБК;
	
КонецФункции

// Возвращает тип налога по КБК, если определить не удалось возвращает ПрочиеНалогиИСборы
//
// Параметры:
//   КодБК - Строка
// 
// Возвращаемое значение:
//   ПеречислениеСсылка.ТипыНалогов
//
Функция ТипНалогаПоКБК(Знач КодБК) Экспорт
	
	ТипНалога = ПрочиеНалогиИСборы;
	Если НЕ ПлатежиВБюджетКлиентСервер.КБКЗадан(КодБК) Тогда
		Возврат ТипНалога;
	КонецЕсли;
	
	ШаблонСравнения = ШаблонСравненияКБК(КодБК);
	Для Каждого Элемент Из Перечисления.ТипыНалогов Цикл
		Если ШаблонСравнения = ШаблонСравненияКБК(КБКПоТипуНалога(Элемент)) Тогда
			ТипНалога = Элемент;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ТипНалога;
	
КонецФункции

//-- Локализация

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

//++ Локализация

Функция КБКПоТипуНалога(ТипНалога)
	
	КодБК = "";
	Если ТипНалога = ЕдиныйНалоговыйПлатеж Тогда
		КодБК = "18201061201010000510";	// ЕдиныйНалоговыйПлатеж
	
	// ++ НЕ УТ
	
	ИначеЕсли ТипНалога = ЕНВД Тогда
		КодБК = "18210502010020000110";	// ЕНВД
	ИначеЕсли ТипНалога = ЕСХН Тогда
		КодБК = "18210503010010000110";	// ЕСХН
	ИначеЕсли ТипНалога = НалогНаИмущество Тогда
		КодБК = "18210602010020000110";	// НалогНаИмущество
	ИначеЕсли ТипНалога = НалогНаПрибыль_РегиональныйБюджет Тогда
		КодБК = "18210101012020000110";	// НалогНаПрибыль_РегиональныйБюджет
	ИначеЕсли ТипНалога = НалогНаПрибыль_ФедеральныйБюджет Тогда
		КодБК = "18210101011010000110";	// НалогНаПрибыль_ФедеральныйБюджет
	ИначеЕсли ТипНалога = НДС Тогда
		КодБК = "18210301000010000110";	// НДС
	ИначеЕсли ТипНалога = НДС_НалоговыйАгент Тогда
		КодБК = "18210301000010000110";	// НДС
	ИначеЕсли ТипНалога = НДС_ВвозимыеТовары Тогда
		КодБК = "18210401000010000110";	// НДС_ВвозимыеТовары
	ИначеЕсли ТипНалога = НДФЛ Тогда
		КодБК = "18210102010010000110";	// НДФЛ
	ИначеЕсли ТипНалога = НДФЛСПревышения Тогда
		КодБК = "18210102080010000110";	// НДФЛ_ДоходыСвышеПредельнойВеличины, НДФЛ_ИП_НалоговаяБазаСвышеПредельнойВеличины
	ИначеЕсли ТипНалога = НДФЛДивиденды Тогда
		КодБК = "18210102130010000110";	// НДФЛ_Дивиденды
	ИначеЕсли ТипНалога = НДФЛДивидендыСПревышения Тогда
		КодБК = "18210102140010000110";	// НДФЛ_Дивиденды_ДоходыСвышеПредельнойВеличины
	ИначеЕсли ТипНалога = НДФЛ_ИП Тогда
		КодБК = "18210102010010000110";	// НДФЛ
	ИначеЕсли ТипНалога = ПФРДополнительныйТарифЛЭ Тогда
		КодБК = "18210208000060000160";	// ДополнительныеВзносы_ПФР_ЛетныеЭкипажи
	ИначеЕсли ТипНалога = ПФРДополнительныйТарифШахтеры Тогда
		КодБК = "18210209000060000160";	// ДополнительныеВзносы_ПФР_Шахтеры
	ИначеЕсли ТипНалога = ПФРЗаЗанятыхНаПодземныхИВредныхРаботах Тогда
		КодБК = "18210204010010000160";	// ДополнительныеВзносы_ПФР_ВредныеУсловия
	ИначеЕсли ТипНалога = ПФРЗаЗанятыхНаТяжелыхИПрочихРаботах Тогда
		КодБК = "18210204020010000160";	// ДополнительныеВзносы_ПФР_ТяжелыеУсловия
	ИначеЕсли ТипНалога = ПФРНакопительнаяЧасть Тогда
		КодБК = "18210202020060000160";	// СтраховыеВзносы_ПФР_НакопительнаяЧасть
	ИначеЕсли ТипНалога = ПФРСтраховаяЧасть Тогда
		КодБК = "18210214010060000160";	// СтраховыеВзносы_ПФР_СтраховаяЧасть
	ИначеЕсли ТипНалога = ТорговыйСбор Тогда
		КодБК = "18210505010020000110";	// ТорговыйСбор
	ИначеЕсли ТипНалога = ТранспортныйНалог Тогда
		КодБК = "18210604011020000110";	// ТранспортныйНалог
	ИначеЕсли ТипНалога = УСН_Доходы Тогда
		КодБК = "18210501011010000110";	// УСН_Доходы
	ИначеЕсли ТипНалога = УСН_ДоходыМинусРасходы Тогда
		КодБК = "18210501021010000110";	// УСН_ДоходыМинусРасходы
	ИначеЕсли ТипНалога = УСН_МинимальныйНалог Тогда
		КодБК = "18210501050010000110";	// УСН_МинимальныйНалог
	ИначеЕсли ТипНалога = ФСС Тогда
		КодБК = "18210214020060000160";	// СтраховыеВзносы_ФСС
	ИначеЕсли ТипНалога = ФССНС Тогда
		КодБК = "79710212000060000160";	// СтраховыеВзносы_ФСС_НСиПЗ
	ИначеЕсли ТипНалога = ФФОМС Тогда
		КодБК = "18210214030080000160";	// СтраховыеВзносы_ФФОМС
	ИначеЕсли ТипНалога = СтраховыеВзносыЕдиныйТариф Тогда
		КодБК = "18210201000010000160";	// СтраховыеВзносыЕдиныйТариф
	ИначеЕсли ТипНалога = ОПСИностранныхРаботников Тогда
		КодБК = "18210215010060000160";	// СтраховыеВзносы_ОПС_ИностранныеРаботники
	ИначеЕсли ТипНалога = ОМСИностранныхРаботников Тогда
		КодБК = "18210215030080000160";	// СтраховыеВзносы_ОМС_ИностранныеРаботники
	ИначеЕсли ТипНалога = ОССИностранныхРаботников Тогда
		КодБК = "18210215020060000160";	// СтраховыеВзносы_ОСС_ИностранныеРаботники
	//-- НЕ УТ
	
	КонецЕсли;
	
	Возврат КодБК;
	
КонецФункции

//++ НЕ УТ

Функция КодПодвидаДоходов(КБК, ТипНалога, ВидНалоговогоОбязательства, Знач Период)
	
	ЭтоНалог    = ВидНалоговогоОбязательства = Перечисления.ВидыПлатежейВГосБюджет.Налог;
	ЭтоПени     = Перечисления.ВидыПлатежейВГосБюджет.ЭтоПени(ВидНалоговогоОбязательства);
	ЭтоПроценты = Перечисления.ВидыПлатежейВГосБюджет.ЭтоПроценты(ВидНалоговогоОбязательства);
	ЭтоШтраф    = Перечисления.ВидыПлатежейВГосБюджет.ЭтоШтраф(ВидНалоговогоОбязательства);
	
	ЭтоВзносыСвышеПредела = ВидНалоговогоОбязательства = Перечисления.ВидыПлатежейВГосБюджет.ВзносыСвышеПредела;
	
	ЭтоТаможенныйПлатеж = ПлатежиВБюджетКлиентСервер.ПлатежАдминистрируетсяТаможеннымиОрганами(КБК);
	КодПодвидаДоходаПоУмолчанию = "0000";
	ТекущийКодПодвидаДохода = ПлатежиВБюджетКлиентСервер.КодПодвидаДоходов(КБК);
	ЭтоОсобыйКодПодвидаДохода = СтрНачинаетсяС(ТекущийКодПодвидаДохода, "0")
		И Не СтрЗаканчиваетсяНа(ТекущийКодПодвидаДохода, "00");
	
	СоответствиеСтраховыхДо2023 = СоответствиеКБКСтраховыхВзносов2022ГодаВ2023Году();
	КБКПриведенный = ПлатежиВБюджетКлиентСервер.ШаблонКБК(КБК);
	ВидСтраховогоВзносаДо2023 = СоответствиеСтраховыхДо2023[КБКПриведенный];
	ЭтоСтарыйСтраховойВзносДо2023 = ЗначениеЗаполнено(ВидСтраховогоВзносаДо2023);
	
	Если ТипНалога = ФФОМС Тогда
		
		Если ПлатежиВБюджетКлиентСервер.ДействуетФедеральныйЗакон263ФЗ(Период) // дата платежа больше 2023 года
			И Не ЭтоСтарыйСтраховойВзносДо2023 Тогда
			КодПодвидаДоходов = "1001";
		Иначе
			КодПодвидаДоходов = "1013";
			Если ЭтоПени Тогда
				КодПодвидаДоходов = "2013";
			ИначеЕсли ЭтоПроценты Тогда
				КодПодвидаДоходов = "2213";
			ИначеЕсли ЭтоШтраф Тогда
				КодПодвидаДоходов = "3013";
			КонецЕсли;
		КонецЕсли;
		
	ИначеЕсли ТипНалога = СтраховыеВзносыЕдиныйТариф Тогда
		
		// Пени и проценты по этим фиксированным страховым не предусмотрены
		Если ЭтоШтраф Тогда
			КодПодвидаДоходов = "3";
		Иначе
			КодПодвидаДоходов = "1";
		КонецЕсли;
		
	ИначеЕсли ТипНалога = ОПСИностранныхРаботников
		Или ТипНалога = ОМСИностранныхРаботников
		Или ТипНалога = ОССИностранныхРаботников Тогда
		
		// Пени и проценты по этим фиксированным страховым не предусмотрены
		Если ЭтоШтраф Тогда
			КодПодвидаДоходов = "3";
		Иначе
			КодПодвидаДоходов = "1";
		КонецЕсли;
		
	ИначеЕсли ТипНалога = ПФРЗаЗанятыхНаПодземныхИВредныхРаботах
		ИЛИ ТипНалога = ПФРЗаЗанятыхНаТяжелыхИПрочихРаботах Тогда
		
		КодПодвидаДоходаДоИзменения = ПлатежиВБюджетКлиентСервер.КодПодвидаДоходов(КБК);
		НеЗависитОтСпецОценки = СтрЗаканчиваетсяНа(КодПодвидаДоходаДоИзменения, "10");
		Если ЭтоНалог Тогда
			КодПодвидаДоходов = "102";
		ИначеЕсли ЭтоПени Тогда
			Если НеЗависитОтСпецОценки Тогда
				КодПодвидаДоходов = "211";
			Иначе
				КодПодвидаДоходов = "210";
			КонецЕсли;
		ИначеЕсли ЭтоПроценты Тогда
			Если НеЗависитОтСпецОценки Тогда
				КодПодвидаДоходов = "221";
			Иначе
				КодПодвидаДоходов = "220";
			КонецЕсли;
		ИначеЕсли ЭтоШтраф Тогда
			Если НеЗависитОтСпецОценки Тогда
				КодПодвидаДоходов = "301";
			Иначе
				КодПодвидаДоходов = "300";
			КонецЕсли
		Иначе
			КодПодвидаДоходов = "101";
		КонецЕсли;
		
	ИначеЕсли ТипНалога = ПФРДополнительныйТарифЛЭ
		ИЛИ ТипНалога = ПФРДополнительныйТарифШахтеры Тогда
		
		Если ЭтоНалог Тогда
			КодПодвидаДоходов = "1";
		ИначеЕсли ЭтоПени Или ЭтоПроценты Тогда
			КодПодвидаДоходов = "21";
		ИначеЕсли ЭтоШтраф Тогда
			КодПодвидаДоходов = "3";
		КонецЕсли;
		
	ИначеЕсли ЭтоТаможенныйПлатеж И ЭтоАвансовыйПлатежТаможня(КБК) Тогда
		
		КодПодвидаДоходов = "1000";
		
	ИначеЕсли ПлатежиВБюджетКлиентСервер.ЭтоЕдиныйНалоговыйПлатеж(КБК) Тогда
		
		КодПодвидаДоходов = КодПодвидаДоходаПоУмолчанию;
		
	ИначеЕсли (ЭтоПениПоВременнойНетрудоспособности(КБК) Или ЭтоШтрафыПоПлатежу(КБК))
		И ТекущийКодПодвидаДохода = КодПодвидаДоходаПоУмолчанию Тогда
		
		КодПодвидаДоходов = ТекущийКодПодвидаДохода;
		
	ИначеЕсли ЭтоПроцентыПоПлатежу(КБК) Тогда
		
		КодПодвидаДоходов = "2";
		
	Иначе
		
		КодПодвидаДоходов = "1";
		Если ТипНалога = ПФРСтраховаяЧасть Тогда
			
			Если ПлатежиВБюджетКлиентСервер.ДействуетФедеральныйЗакон263ФЗ(Период) // дата платежа больше 2023 года
				И Не ЭтоСтарыйСтраховойВзносДо2023 Тогда
				КодПодвидаДоходов = "1001";
			Иначе
				Если ЭтоНалог Тогда
					КодПодвидаДоходов = "101";
				ИначеЕсли ЭтоПени Тогда
					КодПодвидаДоходов = "211";
				ИначеЕсли ЭтоПроценты Тогда
					КодПодвидаДоходов = "221";
				ИначеЕсли ЭтоШтраф Тогда
					КодПодвидаДоходов = "301";
				КонецЕсли;
			КонецЕсли;
			
		ИначеЕсли ТипНалога = ФСС Тогда
			
			Если ПлатежиВБюджетКлиентСервер.ДействуетФедеральныйЗакон263ФЗ(Период) Тогда
				Если ТекущийКодПодвидаДохода = "1101" Тогда
					КодПодвидаДоходов = ТекущийКодПодвидаДохода;
				Иначе
					КодПодвидаДоходов = "1001";
				КонецЕсли;
			Иначе
				Если ЭтоНалог Тогда
					КодПодвидаДоходов = "101";
				ИначеЕсли ЭтоПени Тогда
					КодПодвидаДоходов = "211";
				ИначеЕсли ЭтоПроценты Тогда
					КодПодвидаДоходов = "221";
				ИначеЕсли ЭтоШтраф Тогда
					КодПодвидаДоходов = "301";
				КонецЕсли;
			КонецЕсли;
			
		ИначеЕсли ЭтоОсобыйКодПодвидаДохода Тогда
			
			КодПодвидаДоходов = ТекущийКодПодвидаДохода;
			
		Иначе
			
			Если ЭтоВзносыСвышеПредела Тогда
				КодПодвидаДоходов = "12";
			ИначеЕсли ЭтоПени ИЛИ ЭтоПроценты Тогда
				КодПодвидаДоходов = "2";
				Если ПлатежиВБюджетКлиентСервер.ПениПроцентыРаздельно(КБК, Период) Тогда
					КодПодвидаДоходов = ?(ЭтоПени, "21", "22");
				КонецЕсли;
			ИначеЕсли ЭтоШтраф Тогда
				КодПодвидаДоходов = "3";
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(КодПодвидаДоходов) Тогда
		КодПодвидаДоходов = "1"; // по умолчанию
	КонецЕсли;
	
	РасположениеЭлемента = ПлатежиВБюджетКлиентСервер.РасположениеЭлементаКБК("КодПодвидаДоходов");
	Для Счетчик = СтрДлина(КодПодвидаДоходов) + 1 По РасположениеЭлемента.Длина Цикл
		КодПодвидаДоходов = КодПодвидаДоходов + "0";
	КонецЦикла;
	
	Возврат КодПодвидаДоходов;
	
КонецФункции

Функция ЭтоАвансовыйПлатежТаможня(КБК)
	
	Возврат ПлатежиВБюджетКлиентСервер.КодВидаДоходов(КБК) = "1100900001";
	
КонецФункции

Функция ЭтоПениПоВременнойНетрудоспособности(КБК)
	
	Возврат ПлатежиВБюджетКлиентСервер.КодВидаДоходов(КБК) = "1161902001";
	
КонецФункции

Функция ЭтоПроцентыПоПлатежу(КБК)
	
	Возврат ПлатежиВБюджетКлиентСервер.КодВидаДоходов(КБК) = "1162000001";
	
КонецФункции

Функция ЭтоШтрафыПоПлатежу(КБК)
	
	Возврат ПлатежиВБюджетКлиентСервер.КодВидаДоходов(КБК) = "1162102006";
	
КонецФункции

Функция СоответствиеКБКСтраховыхВзносов2022ГодаВ2023Году()
	
	Результат = Новый Соответствие;
	
	Результат.Вставить("18210202010060000160", ПФРСтраховаяЧасть);
	Результат.Вставить("18210202101080000160", ФФОМС);
	Результат.Вставить("18210202090070000160", ФСС);
	Результат.Вставить("18210201020010000160", ФСС);
	Результат.Вставить("39310202050070000160", ФССНС);
	
	Возврат Результат;
	
КонецФункции

//-- НЕ УТ

Функция ШаблонСравненияКБК(КБК)
	
	ГраницыАдминистратораКБК  = ПлатежиВБюджетКлиентСервер.РасположениеЭлементаКБК("КодГлавногоАдминистратора");
	ГраницыПеременнойЧастиКБК = ПлатежиВБюджетКлиентСервер.РасположениеЭлементаКБК("КодПодвидаДоходов");
	ШаблонКБК = СтроковыеФункцииКлиентСервер.СформироватьСтрокуСимволов("_", ГраницыАдминистратораКБК.Длина)
		+ Сред(КБК, ГраницыАдминистратораКБК.Начало + ГраницыАдминистратораКБК.Длина);
	ШаблонКБК = Лев(ШаблонКБК, ГраницыПеременнойЧастиКБК.Начало - 1)
		+ СтроковыеФункцииКлиентСервер.СформироватьСтрокуСимволов("_", ГраницыПеременнойЧастиКБК.Длина)
		+ Сред(ШаблонКБК, ГраницыПеременнойЧастиКБК.Начало + ГраницыПеременнойЧастиКБК.Длина);
	
	Возврат ШаблонКБК;
	
КонецФункции

//-- Локализация

#КонецОбласти

#КонецЕсли