#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("Структура") Тогда
		ЗаполнитьДокументПоОтбору(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("СправочникСсылка.ОбъектыЭксплуатации") Тогда
		ОбработкаЗаполненияОбъектЭксплуатации(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.ОбъединениеОС") Тогда
		ЗаполнитьНаОснованииОбъединенияОС(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.РазукомплектацияОС") Тогда
		ЗаполнитьНаОснованииРазукомплектацииОС(ДанныеЗаполнения);
	КонецЕсли;
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	Для Каждого Строка Из ОС Цикл
		
		Если Не Строка.ОбщаяСобственность Тогда
			Строка.ДоляВПравеОбщейСобственностиЧислитель = 0;
			Строка.ДоляВПравеОбщейСобственностиЗнаменатель = 0;
		КонецЕсли;
		
		Если Не Строка.ЖилищноеСтроительство Тогда
			Строка.ДатаРегистрацииПравНаОбъектНедвижимости = '00010101';
		КонецЕсли;
		
		Если Не Строка.ЖилищноеСтроительство Или Дата = Дата(1, 1, 1, 0, 0, 0) Или Год(Дата) >= 2008 Тогда
			Строка.ДатаНачалаПроектирования = '00010101';
		КонецЕсли;
		
	КонецЦикла;
	
	УказаныСпособыОтражениеРасходов = (ОтражениеРасходов.Количество() <> 0);
	
	ПараметрыВыбораСтатейИАналитик = Документы.ПараметрыНачисленияЗемельногоНалога.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ПередЗаписью(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НепроверяемыеРеквизиты = Новый Массив;
	
	Если Дата = Дата(1, 1, 1, 0, 0, 0) Или Год(Дата) >= 2014 Тогда
		НепроверяемыеРеквизиты.Добавить("КодПоОКАТО");
	КонецЕсли;
	
	Если НЕ ПараметрыДействуютСПрошлойДаты Тогда
		НепроверяемыеРеквизиты.Добавить("НачалоДействия");
	КонецЕсли;
	
	ОбработкаПроверкиЗаполненияОС(Отказ, НепроверяемыеРеквизиты);
	ВнеоборотныеАктивыСлужебный.ПроверитьНачалоДействияПараметров(ЭтотОбъект, Отказ);
	
	ПараметрыВыбораСтатейИАналитик = Документы.ПараметрыНачисленияЗемельногоНалога.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, ПараметрыВыбораСтатейИАналитик);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ЗаблокироватьЧитаемыеДанные();

	Документы.ПараметрыНачисленияЗемельногоНалога.ПроверитьБлокировкуВходящихДанныхПриОбновленииИБ(
		НСтр("ru = 'Отмена регистрации земельных участков';
			|en = 'Cancel land plot registration'"));
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Заполнение

Процедура ИнициализироватьДокумент()
	
	Ответственный = Пользователи.ТекущийПользователь();
	
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	
	ПараметрыВыбораСтатейИАналитик = Документы.ПараметрыНачисленияЗемельногоНалога.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ОбработкаЗаполнения(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
КонецПроцедуры

Процедура ЗаполнитьДокументПоОтбору(Основание)

	Если Основание.Свойство("ПараметрыДействуютСПрошлойДаты") Тогда
		
		Если Основание.Свойство("ПериодИсправления") Тогда
			ПериодИсправления = Основание.ПериодИсправления; // СтандартныйПериод
			Если ПериодИсправления.ДатаНачала < НачалоМесяца(ТекущаяДатаСеанса()) Тогда
				НачалоДействия = ПериодИсправления.ДатаНачала;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполненияОбъектЭксплуатации(ДанныеЗаполнения)
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ПараметрыНачисленияЗемельногоНалога.Организация КАК Организация,
	|	ПараметрыНачисленияЗемельногоНалога.КодКатегорииЗемель КАК КодКатегорииЗемель,
	|	ПараметрыНачисленияЗемельногоНалога.КадастровыйНомер КАК КадастровыйНомер,
	|	ПараметрыНачисленияЗемельногоНалога.КадастроваяСтоимость КАК КадастроваяСтоимость,
	|	ПараметрыНачисленияЗемельногоНалога.ОбщаяСобственность КАК ОбщаяСобственность,
	|	ПараметрыНачисленияЗемельногоНалога.ДоляВПравеОбщейСобственностиЧислитель КАК ДоляВПравеОбщейСобственностиЧислитель,
	|	ПараметрыНачисленияЗемельногоНалога.ДоляВПравеОбщейСобственностиЗнаменатель КАК ДоляВПравеОбщейСобственностиЗнаменатель,
	|	ПараметрыНачисленияЗемельногоНалога.ЖилищноеСтроительство КАК ЖилищноеСтроительство,
	|	ПараметрыНачисленияЗемельногоНалога.ДатаНачалаПроектирования КАК ДатаНачалаПроектирования,
	|	ПараметрыНачисленияЗемельногоНалога.ДатаРегистрацииПравНаОбъектНедвижимости КАК ДатаРегистрацииПравНаОбъектНедвижимости,
	|	ПараметрыНачисленияЗемельногоНалога.ПостановкаНаУчетВНалоговомОргане КАК ПостановкаНаУчетВНалоговомОргане,
	|	ПараметрыНачисленияЗемельногоНалога.НалоговыйОрган КАК НалоговыйОрган,
	|	ПараметрыНачисленияЗемельногоНалога.КодПоОКАТО КАК КодПоОКАТО,
	|	ПараметрыНачисленияЗемельногоНалога.НалоговаяСтавка КАК НалоговаяСтавка,
	|	ПараметрыНачисленияЗемельногоНалога.НалоговаяЛьготаПоНалоговойБазе КАК НалоговаяЛьготаПоНалоговойБазе,
	|	ПараметрыНачисленияЗемельногоНалога.КодНалоговойЛьготыОсвобождениеОтНалогообложенияПоСтатье395 КАК КодНалоговойЛьготыОсвобождениеОтНалогообложенияПоСтатье395,
	|	ПараметрыНачисленияЗемельногоНалога.КодНалоговойЛьготыУменьшениеНалоговойБазыПоСтатье391 КАК КодНалоговойЛьготыУменьшениеНалоговойБазыПоСтатье391,
	|	ПараметрыНачисленияЗемельногоНалога.УменьшениеНалоговойБазыПоСтатье391 КАК УменьшениеНалоговойБазыПоСтатье391,
	|	ПараметрыНачисленияЗемельногоНалога.УменьшениеНалоговойБазыНаСумму КАК УменьшениеНалоговойБазыНаСумму,
	|	ПараметрыНачисленияЗемельногоНалога.ДоляНеОблагаемойНалогомПлощадиЧислитель КАК ДоляНеОблагаемойНалогомПлощадиЧислитель,
	|	ПараметрыНачисленияЗемельногоНалога.ДоляНеОблагаемойНалогомПлощадиЗнаменатель КАК ДоляНеОблагаемойНалогомПлощадиЗнаменатель,
	|	ПараметрыНачисленияЗемельногоНалога.НеОблагаемаяНалогомСумма КАК НеОблагаемаяНалогомСумма,
	|	ПараметрыНачисленияЗемельногоНалога.СниженнаяНалоговаяСтавка КАК СниженнаяНалоговаяСтавка,
	|	ПараметрыНачисленияЗемельногоНалога.ПроцентУменьшенияСуммыНалога КАК ПроцентУменьшенияСуммыНалога,
	|	ПараметрыНачисленияЗемельногоНалога.СуммаУменьшенияСуммыНалога КАК СуммаУменьшенияСуммыНалога
	|ИЗ
	|	РегистрСведений.ПараметрыНачисленияЗемельногоНалога.СрезПоследних(
	|			&Период, 
	|			ДатаИсправления = ДАТАВРЕМЯ(1,1,1)
	|				И ОсновноеСредство = &ОсновноеСредство) КАК ПараметрыНачисленияЗемельногоНалога
	|ГДЕ
	|	ПараметрыНачисленияЗемельногоНалога.ОсновноеСредство.ГруппаОС = ЗНАЧЕНИЕ(Перечисление.ГруппыОС.ЗемельныеУчастки)";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ОсновноеСредство", ДанныеЗаполнения);
	Запрос.УстановитьПараметр("Период", ?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДатаСеанса()));
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Количество() > 0 Тогда
		Выборка.Следующий();
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
		ЗаполнитьЗначенияСвойств(ОС.Добавить(), Выборка);
	КонецЕсли;

КонецПроцедуры

Процедура ЗаполнитьНаОснованииОбъединенияОС(Основание)

	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ДанныеДокумента.ОтражатьВРеглУчете КАК ОтражатьВРеглУчете,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.ОсновноеСредство КАК ОсновноеСредство
	|ИЗ
	|	Документ.ОбъединениеОС КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Основание
	|	И ДанныеДокумента.ОсновноеСредство.ГруппаОС = ЗНАЧЕНИЕ(Перечисление.ГруппыОС.ЗемельныеУчастки)";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Основание", Основание);
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		ВызватьИсключение НСтр("ru = 'Регистрация не доступна, т.к. основное средство не является земельным участком';
								|en = 'Registration is not available, because the fixed asset is not a land plot'");
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	
	Если НЕ Выборка.ОтражатьВРеглУчете Тогда
		ВызватьИсключение НСтр("ru = 'Регистрация не доступна, т.к. документ не отражен в регл. учете';
								|en = 'Registration is not available, because the document is not recorded in compl. accounting'");
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
	НоваяСтрока = ОС.Добавить();
	НоваяСтрока.ОсновноеСредство = Выборка.ОсновноеСредство;
	
КонецПроцедуры

Процедура ЗаполнитьНаОснованииРазукомплектацииОС(Основание)

	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ДанныеДокумента.ОсновноеСредство КАК ОсновноеСредство
	|ИЗ
	|	Документ.РазукомплектацияОС.ОС КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Основание
	|	И ДанныеДокумента.ОсновноеСредство.ГруппаОС = ЗНАЧЕНИЕ(Перечисление.ГруппыОС.ЗемельныеУчастки)";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Основание", Основание);
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		ВызватьИсключение НСтр("ru = 'Регистрация не доступна, т.к. в документе отсутствуют земельные участки';
								|en = 'Registration is not available, because there are no land plots in the document'");
	КонецЕсли;
	
	РеквизитыДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Основание, "ОтражатьВРеглУчете,Организация");
	
	Если НЕ РеквизитыДокумента.ОтражатьВРеглУчете Тогда
		ВызватьИсключение НСтр("ru = 'Регистрация не доступна, т.к. документ не отражен в регл. учете';
								|en = 'Registration is not available, because the document is not recorded in compl. accounting'");
	КонецЕсли;
	
	Организация = РеквизитыДокумента.Организация;
	
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = ОС.Добавить();
		НоваяСтрока.ОсновноеСредство = Выборка.ОсновноеСредство;
	
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ПроверкаЗаполнения

Процедура ОбработкаПроверкиЗаполненияОС(Отказ, НепроверяемыеРеквизиты)
	
	НепроверяемыеРеквизиты.Добавить("ОС.ДоляВПравеОбщейСобственностиЧислитель");
	НепроверяемыеРеквизиты.Добавить("ОС.ДоляВПравеОбщейСобственностиЗнаменатель");
	НепроверяемыеРеквизиты.Добавить("ОС.ДатаНачалаПроектирования");
	НепроверяемыеРеквизиты.Добавить("ОС.ДатаРегистрацииПравНаОбъектНедвижимости");
	
	
	ТекстОшибки = НСтр("ru = 'Не заполнена колонка ""%1"" в строке %2 списка ""Основные средства""';
						|en = 'The ""%1"" column in %2 line of the ""Fixed assets"" list is not filled in'");
	
	Для Каждого Строка Из ОС Цикл
		
		Если Строка.ОбщаяСобственность Тогда
			
			Если Не ЗначениеЗаполнено(Строка.ДоляВПравеОбщейСобственностиЧислитель) Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					СтрШаблон(ТекстОшибки, НСтр("ru = 'Числитель доли в праве общей собственности';
												|en = 'Numerator of share in ownership rights'"), Строка.НомерСтроки),
					ЭтотОбъект,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ОС", Строка.НомерСтроки, "ДоляВПравеОбщейСобственностиЧислитель"),
					,
					Отказ);
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(Строка.ДоляВПравеОбщейСобственностиЗнаменатель) Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					СтрШаблон(ТекстОшибки, НСтр("ru = 'Знаменатель доли в праве общей собственности';
												|en = 'Denominator of share in ownership rights'"), Строка.НомерСтроки),
					ЭтотОбъект,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ОС", Строка.НомерСтроки, "ДоляВПравеОбщейСобственностиЗнаменатель"),
					,
					Отказ);
			КонецЕсли;
			
		КонецЕсли;
		
		Если Строка.ЖилищноеСтроительство
			И Дата <> Дата(1, 1, 1, 0, 0, 0)
			И Год(Дата) < 2008
			И Не ЗначениеЗаполнено(Строка.ДатаНачалаПроектирования) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтрШаблон(ТекстОшибки, НСтр("ru = 'Дата начала проектирования';
											|en = 'Design start date'"), Строка.НомерСтроки),
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ОС", Строка.НомерСтроки, "ДатаНачалаПроектирования"),
				,
				Отказ);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура ЗаблокироватьЧитаемыеДанные()

	Блокировка = Новый БлокировкаДанных;
	
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ПараметрыНачисленияЗемельногоНалога");
	ЭлементБлокировки.ИсточникДанных = ОС;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("ОсновноеСредство", "ОсновноеСредство");
	ЭлементБлокировки.УстановитьЗначение("Организация", Организация);
	
	Блокировка.Заблокировать(); 
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
