
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Организация   = Параметры.Организация;
	Банк          = Параметры.Банк;
	НачалоПериода = Параметры.НачалоПериода;
	КонецПериода  = Параметры.КонецПериода;
	
	ВидПрепятствияДляСоздания = Параметры.ВидПрепятствияДляСоздания;
	ОписаниеПрепятствийДляСоздания = Параметры.ОписаниеПрепятствийДляСоздания;
	
	// Ограничим список выбираемых организаций только теми, данных которых пользователь может просматривать.
	ДоступныеОрганизации = ОбщегоНазначенияБПВызовСервераПовтИсп.ВсеОрганизацииДанныеКоторыхДоступныПоRLS(Ложь);
	ПараметрыВыбораОрганизации = Новый Массив();
	ПараметрыВыбораОрганизации.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", ДоступныеОрганизации));
	Элементы.Организация.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбораОрганизации);
	
	ОргПоУмолчанию = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
	Если ДоступныеОрганизации.Найти(ОргПоУмолчанию) = Неопределено Тогда
		ОргПоУмолчанию = Неопределено;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Организация) И ЗначениеЗаполнено(ОргПоУмолчанию) Тогда
		Организация = ОргПоУмолчанию;
	КонецЕсли;
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") Тогда
		Организация = ОргПоУмолчанию;
	КонецЕсли;
	
	ЗаполнитьСписокБанков();
	
	ОбновитьКомплектыОтчетности();
	
	УправлениеФормой(ЭтотОбъект);
	
	КлючСохраненияПоложенияОкна = Строка(Новый УникальныйИдентификатор);
	
	АвтозаполнениеОтчетов = ЗаполнениеФинОтчетностиВБанки.ПолучитьПараметрАвтозаполнение();
	
	ПоказатьСкрытьБаннер();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьПериод(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	
	Если Периодичность = "Квартал" Тогда
		Если СНачалаГода Тогда
			ПараметрыВыбора = Новый Структура("НачалоПериода, КонецПериода, НарастающимИтогом", 
				НачалоМесяца(КонецПериода), КонецМесяца(КонецПериода), Истина);
			ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериодаКвартал", ПараметрыВыбора, ЭтотОбъект,,,, ОписаниеОповещения);
		Иначе
			ПараметрыВыбора = Новый Структура("НачалоПериода, КонецПериода", НачалоКвартала(КонецПериода), КонецКвартала(КонецПериода));
			ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериодаКвартал", ПараметрыВыбора, ЭтотОбъект,,,, ОписаниеОповещения);
		КонецЕсли;
	Иначе
		ПараметрыВыбора = Новый Структура("НачалоПериода, КонецПериода", НачалоМесяца(КонецПериода), КонецМесяца(КонецПериода));
		ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериодаМесяц", ПараметрыВыбора, ЭтотОбъект,,,, ОписаниеОповещения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПредыдущийПериод(Команда)
	
	ИзменитьПериод(ЭтотОбъект, -ШагПериода());
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСледующийПериод(Команда)
	
	ИзменитьПериод(ЭтотОбъект, ШагПериода());
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуОтчета(Команда)
	
	// Ошибки показываются в виде предупреждений, а не простых сообщений пользователю,
	// т.к. форма небольшая по размеру и сообщения внизу занимают почти половину от самой формы.
	// Сбербанк не описывается в сервисе. Проверки на актуальность сведений сервиса игнорируются.
	
	ЭтоСбербанк = ЗначениеЗаполнено(Банк)
		И НЕ ФинОтчетностьВБанкиКлиентСервер.ЭтоБанкУниверсальногоОбмена(Банк);
		
	Если НЕ ЭтоСбербанк Тогда
		ОповещениеОЗакрытии = Новый ОписаниеОповещения("ЗакрытьФормуПослеПредупреждения", ЭтотОбъект);
		
		Если ВидПрепятствияДляСоздания = "НетИнтернетПоддержки" Тогда
			ПоказатьПредупреждение(ОповещениеОЗакрытии,
				НСтр("ru = 'Для создания и отправки отчетности необходимо подключить Интернет-поддержку';
					|en = 'To create and send the reporting, enable Online support'"));
			Возврат;
		ИначеЕсли ЗначениеЗаполнено(ВидПрепятствияДляСоздания) Тогда
			Если НЕ ЗначениеЗаполнено(ОписаниеПрепятствийДляСоздания) Тогда
				ТекстСообщения = НСтр("ru = 'Произошла ошибка при обновлении данных сервиса';
										|en = 'An error occurred when updating the service data'");
			Иначе
				ТекстСообщения = ОписаниеПрепятствийДляСоздания;
			КонецЕсли;
			ПоказатьПредупреждение(ОповещениеОЗакрытии, ТекстСообщения);
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения( , , НСтр("ru = 'Организация';
																						|en = 'Company'"));
		ПоказатьПредупреждение(, ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Банк) Тогда
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения( , , НСтр("ru = 'Получатель';
																						|en = 'Recipient'"));
		ПоказатьПредупреждение(, ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ИдентификаторКомплекта) Тогда
		Если Элементы.НесколькоКомплектов.СписокВыбора.Количество() > 0 Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения( , , НСтр("ru = 'Наименование';
																							|en = 'Name'"));
		Иначе
			ТекстСообщения = СтрШаблон(
				НСтр("ru = 'Отсутствуют доступные отчеты для %1';
					|en = 'There are no available reports for %1'"),
				Банк);
		КонецЕсли;

		ПоказатьПредупреждение(, ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	Если (ЗначениеЗаполнено(ДатаОкончанияДействияКомплекта) И КонецПериода > ДатаОкончанияДействияКомплекта)
		Или (ЗначениеЗаполнено(ДатаНачалаДействияКомплекта) И НачалоПериода < ДатаНачалаДействияКомплекта) Тогда
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, "КОРРЕКТНОСТЬ", НСтр("ru = 'Период';
																									|en = 'Period'"));
		ПоказатьПредупреждение(, ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	Если ФинОтчетностьВБанкиКлиентСервер.ЭтоБанкУниверсальногоОбмена(Банк) Тогда
	
		// Для работы с электронными подписями у присоединенных файлов включим соответствующую опцию БСП.
		ПроверитьВключитьОпциюИспользоватьЭлектронныеПодписи();
	
		// Создаем пакет отчетов для сервиса 1С:ФинОтчетность в банки.
		ЗначенияЗаполнения = Новый Структура();
		ЗначенияЗаполнения.Вставить("Организация",                   Организация);
		ЗначенияЗаполнения.Вставить("Банк",                          Банк);
		ЗначенияЗаполнения.Вставить("НачалоПериода",                 НачалоПериода);
		ЗначенияЗаполнения.Вставить("КонецПериода",                  КонецМесяца(КонецПериода));
		ЗначенияЗаполнения.Вставить("ИдентификаторКомплекта",        ИдентификаторКомплекта);
		ЗначенияЗаполнения.Вставить("КраткоеПредставлениеКомплекта", КраткоеПредставлениеКомплекта);
		
		ЗначенияЗаполнения.Вставить("АвтозаполнениеОтчетовПриОткрытии", АвтозаполнениеОтчетов);
		
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
		
		ОткрытьФорму("Документ.ФинОтчетВБанк.Форма.ФормаДокумента", ПараметрыФормы, , Истина);
	
	Иначе
		// Создаем отчет БРО БухгалтерскаяОтчетностьВБанк.
		СистемнаяИнформация = Новый СистемнаяИнформация;
		ПараметрыКлиента = Новый Структура;
		ПараметрыКлиента.Вставить("ТипПлатформы", Строка(СистемнаяИнформация.ТипПлатформы));
		ПараметрыКлиента.Вставить("ВерсияОС",     СистемнаяИнформация.ВерсияОС);
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("мДатаНачалаПериодаОтчета", НачалоПериода);
		ПараметрыФормы.Вставить("мДатаКонцаПериодаОтчета",  КонецМесяца(КонецПериода));
		ПараметрыФормы.Вставить("Организация",              Организация);
		ПараметрыФормы.Вставить("мВыбраннаяФорма",          ИдентификаторКомплекта);
		ПараметрыФормы.Вставить("Банк",                     Банк);
		
		ОткрытьФорму("Отчет.БухгалтерскаяОтчетностьВБанк.Форма." + ИдентификаторКомплекта, ПараметрыФормы, , Истина);
		
	КонецЕсли;
	
	СохранитьНастройкиАвтозаполненияНаСервере(АвтозаполнениеОтчетов);
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура БанкПриИзменении(Элемент)
	
	ОбновитьКомплектыОтчетности();
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ИдентификаторКомплектаПриИзменении(Элемент)
	
	ИдентификаторКомплектаПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункци

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	Элементы.ПериодОтчета.КнопкаВыбора = Форма.Периодичность <> "Год";
	
	Если ФинОтчетностьВБанкиКлиентСервер.ЭтоБанкУниверсальногоОбмена(Форма.Банк) Тогда
	
		Элементы.ГруппаАвтоматическиЗаполнять.Видимость = Истина;
	
	Иначе
	
		Элементы.ГруппаАвтоматическиЗаполнять.Видимость = Ложь;
	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПериодПоУмолчанию()
	
	ТекущаяДата = УниверсальныйОбменСБанкамиВызовСервера.ТекущаяДатаНаСервере();
	ЭтоПервыйКвартал = НачалоКвартала(ТекущаяДата) = НачалоГода(ТекущаяДата);
	
	Если Периодичность = "Год" Тогда
		КонецПериода = ПредыдущийГод(ТекущаяДата);
		Если ЭтоПервыйКвартал И ПодставлятьПоУмолчаниюПредпоследнийЗакрытыйПериод Тогда
			КонецПериода = ПредыдущийГод(КонецПериода);
		КонецЕсли;
	ИначеЕсли Периодичность = "Квартал" Тогда
		КонецПериода = ПредыдущийКвартал(ТекущаяДата);
		Если ЭтоПервыйКвартал И ПодставлятьПоУмолчаниюПредпоследнийЗакрытыйПериод Тогда
			КонецПериода = ПредыдущийКвартал(КонецПериода);
		КонецЕсли;
	Иначе
		КонецПериода  = ПредыдущийМесяц(ТекущаяДата);
		Если ЭтоПервыйКвартал И ПодставлятьПоУмолчаниюПредпоследнийЗакрытыйПериод Тогда
			КонецПериода = ПредыдущийМесяц(КонецПериода);
		КонецЕсли;
	КонецЕсли;
	
	ИзменитьПериод(ЭтотОбъект, 0);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПредыдущийМесяц(Дата)
	
	Возврат КонецМесяца(НачалоМесяца(Дата) - 1);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПредыдущийКвартал(Дата)
	
	Возврат КонецКвартала(НачалоКвартала(Дата) - 1);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПредыдущийГод(Дата)
	
	Возврат КонецГода(НачалоГода(Дата) - 1);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьПериод(Форма, Шаг)
	
	Форма.КонецПериода  = КонецМесяца(ДобавитьМесяц(Форма.КонецПериода, Шаг));
	
	Если Форма.Периодичность = "Год" ИЛИ Форма.СНачалаГода Тогда
		Форма.НачалоПериода = НачалоГода(Форма.КонецПериода);
	ИначеЕсли Форма.Периодичность = "Квартал" Тогда
		Форма.НачалоПериода = НачалоКвартала(Форма.КонецПериода);
	Иначе
		Форма.НачалоПериода = НачалоМесяца(Форма.КонецПериода);
	КонецЕсли;
	
	Форма.ПериодОтчета = ПредставлениеПериода(Форма.НачалоПериода, КонецДня(Форма.КонецПериода), "ФП = Истина");
	
	// Проверка применимости отчета в указанном периоде
	Если (ЗначениеЗаполнено(Форма.ДатаОкончанияДействияКомплекта) И Форма.КонецПериода > Форма.ДатаОкончанияДействияКомплекта)
		Или (ЗначениеЗаполнено(Форма.ДатаНачалаДействияКомплекта) И Форма.НачалоПериода < Форма.ДатаНачалаДействияКомплекта) Тогда
		Если НачалоДня(Форма.ДатаОкончанияДействияКомплекта) = КонецВремен() Тогда
			Форма.Элементы.ПериодОтчета.РасширеннаяПодсказка.Заголовок = СтрШаблон(НСтр("ru = 'Период действия: с %1';
																						|en = 'Valid from: %1'"),
				Формат(Форма.ДатаНачалаДействияКомплекта, "ДФ=dd.MM.yyyy"));
		Иначе
			Форма.Элементы.ПериодОтчета.РасширеннаяПодсказка.Заголовок = СтрШаблон(НСтр("ru = 'Период действия: %1-%2';
																						|en = 'Validity period: %1-%2'"),
				Формат(Форма.ДатаНачалаДействияКомплекта, "ДФ=dd.MM.yyyy"), Формат(Форма.ДатаОкончанияДействияКомплекта, "ДФ=dd.MM.yyyy"));
		КонецЕсли;
	Иначе
		Форма.Элементы.ПериодОтчета.РасширеннаяПодсказка.Заголовок = "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция КонецВремен()
	
	Возврат Дата(2999, 12, 31);
	
КонецФункции

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НачалоПериода = РезультатВыбора.НачалоПериода;
	КонецПериода  = РезультатВыбора.КонецПериода;
	
	ИзменитьПериод(ЭтотОбъект, 0);
	
КонецПроцедуры

&НаКлиенте
Функция ШагПериода()
	
	Если Периодичность = "Год" Тогда
		Возврат 12;
	ИначеЕсли Периодичность = "Квартал" Тогда
		Возврат 3;
	Иначе
		Возврат 1;
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСписокБанков()

	СписокВыбора = Элементы.Банк.СписокВыбора;
	СписокВыбора.Очистить();
	
	ДоступныеБанки = ФинОтчетностьВБанки.ДоступныеБанки(Ложь);
	
	Для каждого ЭлементСписка Из ДоступныеБанки Цикл
		СписокВыбора.Добавить(ЭлементСписка.Значение, ЭлементСписка.Представление);
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ОбновитьКомплектыОтчетности()
	
	СписокВыбора = Элементы.НесколькоКомплектов.СписокВыбора;
	СписокВыбора.Очистить();
	
	Если ЗначениеЗаполнено(Банк) Тогда
		// Проверим, были ли ранее считаны данные о требованиях банка к отчетности.
		Отбор = Новый Структура();
		Отбор.Вставить("Банк", Банк);
		
		НайденныеСтроки = КомплектыОтчетности.НайтиСтроки(Отбор);
		
		Если НайденныеСтроки.Количество() = 0 Тогда
			
			Если ФинОтчетностьВБанкиКлиентСервер.ЭтоБанкУниверсальногоОбмена(Банк) Тогда
				
				// Ранее не получали по выбранному банку комплекты отчетности, получаем их сейчас.
				КомплектыОтчетностиБанка = ЗаполнениеФинОтчетностиВБанки.КомплектыОтчетности(Банк);
				Для каждого СтрокаКомплекта Из КомплектыОтчетностиБанка Цикл
					Если СтрокаКомплекта.Архивный Тогда
						Продолжить;
					КонецЕсли;
					
					НоваяСтрока = КомплектыОтчетности.Добавить();
					НоваяСтрока.Банк = Банк;
					ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаКомплекта);
					
					НайденныеСтроки.Добавить(НоваяСтрока);
				КонецЦикла;
				
			Иначе
				// Задаем настройки по умолчанию для актуальной формы отчета БРО БухгалтерскаяОтчетностьВБанк.
				НоваяСтрока = КомплектыОтчетности.Добавить();
				НоваяСтрока.Банк                   = Банк;
				НоваяСтрока.Идентификатор          = "ФормаОтчета2017Кв3";
				 // Всегда используем фиксированное значение.
				НоваяСтрока.КраткоеПредставление   = ФинОтчетностьВБанки.НаименованиеОтчетностиВСбербанк();
				НоваяСтрока.ПодробноеПредставление = "";
				НоваяСтрока.ДатаНачала             = '0001-01-01';
				НоваяСтрока.ДатаОкончания          = '2999-12-31';
				
				НайденныеСтроки.Добавить(НоваяСтрока);
			КонецЕсли;
		КонецЕсли;
		
		Для каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			СписокВыбора.Добавить(НайденнаяСтрока.Идентификатор, НайденнаяСтрока.КраткоеПредставление);
		КонецЦикла;
		
	КонецЕсли;
	
	Если СписокВыбора.Количество() > 1 Тогда
		Элементы.НесколькоКомплектов.Видимость = Истина;
		Элементы.ОдинКомплект.Видимость        = Ложь;
		ИдентификаторКомплекта        = "";
		КраткоеПредставлениеКомплекта = "";
	Иначе
		Элементы.НесколькоКомплектов.Видимость = Ложь;
		Элементы.ОдинКомплект.Видимость        = Истина;
		
		Если СписокВыбора.Количество() > 0 Тогда
			ИдентификаторКомплекта        = СписокВыбора[0].Значение;
			КраткоеПредставлениеКомплекта = СписокВыбора[0].Представление;
		Иначе
			ИдентификаторКомплекта        = "";
			КраткоеПредставлениеКомплекта = "";
		КонецЕсли;
	КонецЕсли;
	
	ЗаполнитьДанныеКомплекта(ИдентификаторКомплекта);
	
	УстановитьПериодПоУмолчанию();
	
	ОбновитьПодсказкуНазначения(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеКомплекта(Идентификатор)
	
	Отбор = Новый Структура();
	Отбор.Вставить("Идентификатор", Идентификатор);
	
	НайденныеСтроки = КомплектыОтчетности.НайтиСтроки(Отбор);
	Если НайденныеСтроки.Количество() > 0 Тогда
		НайденнаяСтрока =  НайденныеСтроки[0];
		Периодичность = НайденнаяСтрока.Периодичность;
		СНачалаГода = НайденнаяСтрока.СНачалаГода;
		ДатаНачалаДействияКомплекта = НайденнаяСтрока.ДатаНачала;
		ДатаОкончанияДействияКомплекта = НайденнаяСтрока.ДатаОкончания;
		ПодставлятьПоУмолчаниюПредпоследнийЗакрытыйПериод = НайденнаяСтрока.ПодставлятьПоУмолчаниюПредпоследнийЗакрытыйПериод;
	Иначе
		Периодичность = Неопределено;
		ДатаНачалаДействияКомплекта = Неопределено;
		ДатаОкончанияДействияКомплекта = Неопределено;
		ПодставлятьПоУмолчаниюПредпоследнийЗакрытыйПериод = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьПодсказкуНазначения(Форма)

	Элементы = Форма.Элементы;
	ЭлементСПодсказкой = Элементы.ГруппаУправлениеПериодом;
	
	Отбор = Новый Структура();
	Отбор.Вставить("Банк",          Форма.Банк);
	Отбор.Вставить("Идентификатор", Форма.ИдентификаторКомплекта);
	
	НайденныеСтроки = Форма.КомплектыОтчетности.НайтиСтроки(Отбор);
	Если НайденныеСтроки.Количество() > 0 Тогда
		ЭлементСПодсказкой.Подсказка = НайденныеСтроки[0].ПодробноеПредставление;
	Иначе
		ЭлементСПодсказкой.Подсказка = "";
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПроверитьВключитьОпциюИспользоватьЭлектронныеПодписи()

	Если ЭлектроннаяПодпись.ИспользоватьЭлектронныеПодписи() Тогда
		Возврат;
	КонецЕсли;

	УстановитьПривилегированныйРежим(Истина);
	Константы.ИспользоватьЭлектронныеПодписи.Установить(Истина);
	УстановитьПривилегированныйРежим(Ложь);
	
	ОбновитьПовторноИспользуемыеЗначения();

КонецПроцедуры

&НаСервере
Процедура ИдентификаторКомплектаПриИзмененииНаСервере()
	
	ЗаполнитьДанныеКомплекта(ИдентификаторКомплекта);
	
	УстановитьПериодПоУмолчанию();
	
	ОбновитьПодсказкуНазначения(ЭтотОбъект);
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФормуПослеПредупреждения(ДополнительныеПараметры) Экспорт
	
	Если ВидПрепятствияДляСоздания = "НетИнтернетПоддержки" Тогда
		Закрыть("ПодключитьИнтернетПоддержку");
	Иначе
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область РаботаСБаннеромИСохранениемНастроек

&НаСервере
Процедура ПоказатьСкрытьБаннер()
	
	ПоказыватьБаннер = ЗаполнениеФинОтчетностиВБанки.ПолучитьПараметрПоказыватьБаннерАвтозаполнение();
	
	Элементы.БаннерСФоном.Видимость = ПоказыватьБаннер;
	
	Элементы.КартинкаБаннера.Картинка = ЗаполнениеФинОтчетностиВБанки.КартинкаБаннерАвтозаполнение();

	Если ПоказыватьБаннер Тогда
		
		РазмерШрифтаБаннера = 10;
		
		ШрифтТекстаБаннера = Новый Шрифт(ШрифтыСтиля.ШрифтТекстаБаннера,,РазмерШрифтаБаннера);
		
		ТекстБаннера = Новый ФорматированнаяСтрока(
			Новый ФорматированнаяСтрока(НСтр("ru = 'Включение флажка ';
											|en = 'Select check box'"), ШрифтТекстаБаннера),
			Новый ФорматированнаяСтрока(НСтр("ru = '""Автоматически заполнить"" ';
											|en = '""Fill in automatically""'"), Новый Шрифт(ШрифтТекстаБаннера,,,Истина)),
			Новый ФорматированнаяСтрока(НСтр("ru = 'может замедлить создание пакета, но сократит работу в дальнейшем.
				|Состав отчетов к отправке можно будет изменить';
				|en = 'might slow down package creation but will ease the execution later.
				|You can change reports to be sent'"), ШрифтТекстаБаннера)
		);
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КартинкаЗакрытьБаннерНажатие(Элемент)
	
	Элементы.БаннерСФоном.Видимость = Ложь;
	СохранитьНастройкиБаннераНаСервере(Ложь);
	
КонецПроцедуры
	
&НаСервере
Процедура СохранитьНастройкиБаннераНаСервере(ЗначениеПараметра)
	
	ЗаполнениеФинОтчетностиВБанки.СохранитьПараметрПоказыватьБаннерАвтозаполнение(ЗначениеПараметра);

КонецПроцедуры
	
&НаСервере
Процедура СохранитьНастройкиАвтозаполненияНаСервере(ЗначениеПараметра)
	
	ЗаполнениеФинОтчетностиВБанки.СохранитьПараметрАвтозаполнение(ЗначениеПараметра);

КонецПроцедуры

#КонецОбласти
