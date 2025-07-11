#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	КонтекстЭДОСервер.ПриЗаписиОбъекта(ЭтотОбъект, Отказ);

КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Дата) Тогда
		Дата = ТекущаяДатаСеанса();
	КонецЕсли;
	
	ЗаполнитьНаименование();
	
	КонтекстЭДО = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	КонтекстЭДО.ПередЗаписьюОбъекта(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ВходящийКонтекст)
	
	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	КонтекстЭДОСервер.ОбработкаЗаполненияОбъекта(ЭтотОбъект, ВходящийКонтекст);
	
	Если ТипЗнч(ВходящийКонтекст) = Тип("Структура") Тогда
	
		Если ВходящийКонтекст.Свойство("Организация") 
			И ЗначениеЗаполнено(ВходящийКонтекст.Организация) Тогда
			Организация = ВходящийКонтекст.Организация;
		КонецЕсли;
		
		Если ВходящийКонтекст.Свойство("Вид") 
			И ЗначениеЗаполнено(ВходящийКонтекст.Вид) Тогда
			Вид = ВходящийКонтекст.Вид;
		КонецЕсли;

		Если ВходящийКонтекст.Свойство("Основание")
			И ТипЗнч(ВходящийКонтекст.Основание) = Тип("ДокументСсылка.ЗаявлениеАбонентаСпецоператораСвязи") Тогда
		
			Основание = ВходящийКонтекст.Основание;
			ЗаполнитьНаОсновеЗаявленияПо1СОтчетности(Основание);
			ЗаполнитьНаОсновеСертификата(Основание); // заполняет только недостающие
			ЗаполнитьИзБазы(Основание.Организация); // заполняет только недостающие
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Организация) Тогда
			ЗаполнитьИзБазы(Организация); // заполняет только недостающие
		КонецЕсли;
		
	Иначе
		
		Если НЕ ЗначениеЗаполнено(Организация) 
			И РегламентированнаяОтчетностьВызовСервера.ИспользуетсяОднаОрганизация() Тогда
			Модуль 		= ОбщегоНазначения.ОбщийМодуль("Справочники.Организации");
			Организация = Модуль.ОрганизацияПоУмолчанию();
		КонецЕсли;
		
	КонецЕсли;
	
	Оператор = Документы.ЗаявленияПоЭлДокументооборотуСПФР.ПараметрыЗаполненияОператора(Организация, Вид);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Оператор);
	
	Дата = МестноеВремя(ТекущаяДатаСеанса(), ЧасовойПоясСеанса());
	
	ПометкаУдаления = Ложь;
		
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Дата = ТекущаяДатаСеанса();
	ПометкаУдаления = Ложь;
	Получатель = Документы.ЗаявленияПоЭлДокументооборотуСПФР.ПолучательЗаявления(Организация);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	КонтекстЭДОСервер     = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	ДействуетФорматАФ245д = КонтекстЭДОСервер.ДействуетФорматАФ245д();

	Если ЗначениеЗаполнено(Организация) Тогда
		
		ЭтоЮридическоеЛицо = РегламентированнаяОтчетностьВызовСервера.ЭтоЮридическоеЛицо(Организация);
		Если ЭтоЮридическоеЛицо Тогда
			ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("СНИЛС"));
		Иначе
			ИсключитьЛишниеРеквизитыДляИП(Отказ, ПроверяемыеРеквизиты);
		КонецЕсли;
		
		ПроверитьИНН("ИНН", Отказ, ЭтоЮридическоеЛицо);
		ПроверитьКПП("КПП", Отказ, ЭтоЮридическоеЛицо);
		ПроверитьРегНомерПФР("РегНомерПФР", Отказ);
		
		Если ДействуетФорматАФ245д Тогда
			ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("АдресРегистрации"));
			ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("АдресФактический"));
		Иначе
			ПроверитьАдрес(Отказ, АдресРегистрации, "Объект.АдресРегистрации", НСтр("ru = 'адрес регистрации';
																					|en = 'адрес регистрации'"));
			ПроверитьАдрес(Отказ, АдресФактический, "Объект.АдресФактический", НСтр("ru = 'фактический адрес';
																					|en = 'фактический адрес'"));
		КонецЕсли;
		
	КонецЕсли;
	
	ПроверитьСНИЛС(Отказ);
	ПроверитьТелефон(Отказ);
	ПроверитьЭлПочту(Отказ);
	ПроверитьОператора(Отказ, ПроверяемыеРеквизиты, ДействуетФорматАФ245д);
	ПроверитьУчетку(Отказ);
	ПроверитьПолучателя(Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьПолучателя(Отказ)
	
	РезультатПроверки = ДокументооборотСКОКлиентСервер.РезультатПроверкиРеквизитов();
	РезультатПроверки.Поле = "Получатель";

	Если ЗначениеЗаполнено(Организация) Тогда
		
		КодОрганаПФРОрганизации = "";
		РегНомерПФРОрганизации = Неопределено;
		РегНомерСФРОрганизации = Неопределено;
		
		ИспользоватьРегНомерСФР = ДокументооборотСКОВызовСервера.СобытиеНаступилоИспользоватьРегНомерСФР();
		
		КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
		ПолучательПоКоду = КонтекстЭДОСервер.ОпределитьОрганПФРОрганизации(
			Организация,
			КодОрганаПФРОрганизации,
			РегНомерПФРОрганизации,
			РегНомерСФРОрганизации,
			ИспользоватьРегНомерСФР);
		
		Если НЕ ЗначениеЗаполнено(Получатель) Тогда
			
			Если ЗначениеЗаполнено(КодОрганаПФРОрганизации) ИЛИ ЗначениеЗаполнено(РегНомерСФРОрганизации) Тогда
				
				УчетнаяЗапись = КонтекстЭДОСервер.УчетнаяЗаписьОрганизации(Организация);
				Если ЗначениеЗаполнено(УчетнаяЗапись) Тогда
					
					Если НЕ ЗначениеЗаполнено(ПолучательПоКоду) Тогда
						
						РезультатПроверки.ТекстОшибки = НСтр("ru = 'Направление ПФР';
															|en = 'Направление ПФР'") + " " + КодОрганаПФРОрганизации
							+ " " + НСтр("ru = 'не подключено';
										|en = 'не подключено'") + ". ";
						Если УчетнаяЗапись.СпецОператорСвязи = Перечисления.СпецоператорыСвязи.КалугаАстрал Тогда
							РезультатПроверки.ТекстОшибки = РезультатПроверки.ТекстОшибки
								+ НСтр("ru = 'Для подключения направления отправьте заявление на подключение направления 1С-Отчетности';
										|en = 'Для подключения направления отправьте заявление на подключение направления 1С-Отчетности'");
						Иначе
							РезультатПроверки.ТекстОшибки = РезультатПроверки.ТекстОшибки
								+ НСтр("ru = 'Для подключения направления обратитесь к своему оператору эл. документооборота';
										|en = 'Для подключения направления обратитесь к своему оператору эл. документооборота'");
						КонецЕсли;
						
					КонецЕсли;
					
				Иначе
					Если ДокументооборотСКОВызовСервера.ЗапоминаниеОшибок(,, Истина, "МЧДТолькоПодписание") <> Истина Тогда
						РезультатПроверки.ТекстОшибки = НСтр("ru = 'Для отправки заявления подключите 1С-Отчетность';
															|en = 'Для отправки заявления подключите 1С-Отчетность'");
					КонецЕсли;
				КонецЕсли;
				
			Иначе
				Если ЗначениеЗаполнено(РегНомерПФРОрганизации) Тогда
					РезультатПроверки.ТекстОшибки = НСтр("ru = 'Укажите код органа ПФР в карточке организации';
														|en = 'Укажите код органа ПФР в карточке организации'");
				Иначе
					РезультатПроверки.ТекстОшибки =
						НСтр("ru = 'Укажите регистрационный номер СФР или регистрационный номер ПФР и код органа ПФР в карточке организации';
							|en = 'Укажите регистрационный номер СФР или регистрационный номер ПФР и код органа ПФР в карточке организации'");
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	УстановитьОтказ(Отказ, РезультатПроверки);
	
КонецПроцедуры

Процедура ПроверитьОператора(Отказ, ПроверяемыеРеквизиты, ДействуетФорматАФ245д)
	
	Если Вид = Перечисления.ВидыЗаявленийНаЭДОВПФР.НаПодключение Тогда
		ПроверитьИНН("ОператорИНН", Отказ, Истина);
		ПроверитьКПП("ОператорКПП", Отказ, Истина);
		ПроверитьРегНомерПФР("ОператорРегНомерПФР", Отказ);
		
		Если ДействуетФорматАФ245д Тогда
			ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("ОператорНаименованиеПолное"));
		КонецЕсли;
		
	Иначе
		ИсключитьЛишниеРеквизитыОператора(Отказ, ПроверяемыеРеквизиты);
	КонецЕсли;
	
КонецПроцедуры

Процедура ИсключитьЛишниеРеквизитыОператора(Отказ, ПроверяемыеРеквизиты)

	ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("ОператорРегНомерПФР"));
	ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("ОператорНаименованиеКраткое"));
	ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("ОператорНаименованиеПолное"));
	ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("ОператорИНН"));
	ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("ОператорКПП"));
	
КонецПроцедуры

Процедура ЗаполнитьНаОсновеЗаявленияПо1СОтчетности(Основание)
	
	Организация = Основание.Организация;
	АдресРегистрации = Основание.АдресЮридический;
	АдресФактический = Основание.АдресФактический;
	ИНН = Основание.ИНН;
	Получатель = Документы.ЗаявленияПоЭлДокументооборотуСПФР.ПолучательЗаявления(Организация);
	
	Если ЗначениеЗаполнено(Основание.РегНомерСФР) Тогда
		РегНомерПФР = Основание.РегНомерСФР;
	Иначе
		РегНомерПФР = Основание.РегНомерПФР;
	КонецЕсли;
	
	ЭтоЮридическоеЛицо = РегламентированнаяОтчетностьВызовСервера.ЭтоЮридическоеЛицо(Организация);
	НаименованиеКраткое = Основание.КраткоеНаименование;
	КПП = Основание.КПП;
	// НаименованиеПолное - здесь нет заполнения полного наименования, потому что оно не хранится в заявлении по 1С-Отчетности
	Фамилия = Основание.ВладелецЭЦПФамилия;
	Имя = Основание.ВладелецЭЦПИмя;
	Отчество = Основание.ВладелецЭЦПОтчество;
	СНИЛС = Основание.ВладелецЭЦПСНИЛС;
	
	Если ЭтоЮридическоеЛицо Тогда
		Должность = Основание.ВладелецЭЦПДолжность;
	КонецЕсли;
		
	Телефон = Основание.ТелефонМобильный;
	ЭлектроннаяПочта = Основание.ЭлектроннаяПочта;

КонецПроцедуры

Процедура ЗаполнитьНаОсновеСертификата(Основание)
	
	// При включении сертификата это сертификат используется для подписания
	// В случае, если используется сертификат для подписания, из него уже будут взяты следующие реквизиты и заполнены в заявлении:
	// - Краткое наименование
	// - Должность
	// - Электронная почта
	// Поэтому эти поля не достаем из сертификата
	// Так же не все реквизиты заявления есть в сертификате.
	// Можно получить только следующие реквизиты:
	// - Фамилия
	// - Имя
	// - Отчество
	// - СНИЛС
	// - ИНН
	
	Сертификат = Основание.РеквизитыСертификата.Получить();
	Если ТипЗнч(Сертификат) = Тип("Структура") Тогда
		
		ВладелецСтруктура = ДокументооборотСКОКлиентСервер.ВладелецСертификат(Сертификат);
		Если Сертификат = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(ИНН) Тогда
			ИНН = ДокументооборотСКОКлиентСервер.ИННИзСертификата(ВладелецСтруктура);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(СНИЛС) Тогда
			СНИЛС = ВладелецСтруктура.SNILS;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Фамилия) Тогда
			Фамилия = ВладелецСтруктура.SN;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Имя) ИЛИ НЕ ЗначениеЗаполнено(Отчество) Тогда
			
			ИмяОтчество = ВладелецСтруктура.GN;
			Позиция = СтрНайти(ИмяОтчество, " ");
			Если Позиция > 0 Тогда
				Имя = Сред(ИмяОтчество, 1, Позиция-1);
				Отчество = Сред(ИмяОтчество, Позиция + 1);
			Иначе
				Имя = ИмяОтчество;
			КонецЕсли
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьИзБазы(Организация)
	
	// Формируем список всех реквизитов и только пустых реквизтов
	Реквизиты    = Метаданные.Документы.ЗаявленияПоЭлДокументооборотуСПФР.Реквизиты;
	ВсеРеквизиты = Новый Структура;
	ПустыеРеквизиты = Новый Массив;
	Для каждого Реквизит Из Реквизиты Цикл
		ВсеРеквизиты.Вставить(Реквизит.Имя);
		Если НЕ ЗначениеЗаполнено(ЭтотОбъект[Реквизит.Имя]) Тогда
			ПустыеРеквизиты.Добавить(Реквизит.Имя);
		КонецЕсли;
	КонецЦикла;
	
	// Для заполнения сертификата
	ВсеРеквизиты.Вставить("Вид", ЭтотОбъект.Вид);
	ВсеРеквизиты.Вставить("Организация", ЭтотОбъект.Организация);
	
	Если ПустыеРеквизиты.Количество() > 0 Тогда
		
		ВсеРеквизиты.Организация = Организация;
		// Заполняем все реквизиты
		Документы.ЗаявленияПоЭлДокументооборотуСПФР.ЗаполнитьИзБазы(ВсеРеквизиты);
		ПустыеРеквизиты = СтрСоединить(ПустыеРеквизиты, ",");
		// Копируем в объект только те реквизиты, которые в объетке пустые
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ВсеРеквизиты, ПустыеРеквизиты);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ИсключитьЛишниеРеквизитыДляИП(Отказ, ПроверяемыеРеквизиты)

	ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("КПП"));
	ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("НаименованиеКраткое"));
	ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("НаименованиеПолное"));
	
КонецПроцедуры

Процедура ЗаполнитьНаименование() Экспорт
	
	Если ЗначениеЗаполнено(Вид) = Перечисления.ВидыЗаявленийНаЭДОВПФР.НаПодключение Тогда 
		Наименование = Строка(Вид);
	Иначе
		Наименование = СтрШаблон("Заявление по эл. документообороту с ПФР");
	КонецЕсли;

КонецПроцедуры

Функция ПроверитьИНН(ИмяРеквизита, Отказ, ЭтоЮридическоеЛицо)
	
	РезультатПроверки = ДокументооборотСКОКлиентСервер.РезультатПроверкиРеквизитов();
	РезультатПроверки.Поле = "Объект." + ИмяРеквизита;
	
	ЭтотОбъект[ИмяРеквизита] = СокрЛП(ЭтотОбъект[ИмяРеквизита]);
	ЗначениеИНН = ЭтотОбъект[ИмяРеквизита];
	
	Представление = Строка(ЭтотОбъект.Метаданные().Реквизиты[ИмяРеквизита]);
	
	// ИНН
	Если ЗначениеЗаполнено(ЗначениеИНН) Тогда
		
		Если ЭтоЮридическоеЛицо И СтрДлина(ЗначениеИНН) <> 10 Тогда
			
			РезультатПроверки.ТекстОшибки = Представление + НСтр("ru = ' должен состоять из 10 цифр';
																|en = ' должен состоять из 10 цифр'");
			РезультатПроверки.Пустой	  = СтрДлина(ЗначениеИНН) < 10;
			
		ИначеЕсли НЕ ЭтоЮридическоеЛицо И СтрДлина(ЗначениеИНН) <> 12 Тогда
				
			РезультатПроверки.ТекстОшибки = Представление + НСтр("ru = ' должен состоять из 12 цифр';
																|en = ' должен состоять из 12 цифр'");
			РезультатПроверки.Пустой	  = СтрДлина(ЗначениеИНН) < 12;

		Иначе
			РегламентированныеДанныеКлиентСервер.ИННСоответствуетТребованиям(ЗначениеИНН, ЭтоЮридическоеЛицо, РезультатПроверки.ТекстОшибки);
			
			Если ЗначениеЗаполнено(РезультатПроверки.ТекстОшибки) Тогда
				РезультатПроверки.ТекстОшибки  = Представление + ": " + РезультатПроверки.ТекстОшибки;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	УстановитьОтказ(Отказ, РезультатПроверки);
	
КонецФункции

Функция ПроверитьКПП(ИмяРеквизита, Отказ, ЭтоЮридическоеЛицо)
	
	РезультатПроверки = ДокументооборотСКОКлиентСервер.РезультатПроверкиРеквизитов();
	РезультатПроверки.Поле = "Объект." + ИмяРеквизита;
	
	ЭтотОбъект[ИмяРеквизита] = СокрЛП(ЭтотОбъект[ИмяРеквизита]);
	ЗначениеКПП = ЭтотОбъект[ИмяРеквизита];
	
	Представление = Строка(ЭтотОбъект.Метаданные().Реквизиты[ИмяРеквизита]);
	
	ТекстОшибки = "";
	Если ЭтоЮридическоеЛицо Тогда

		Если ДокументооборотСКОКлиентСервер.НайденыЗапрещенныеСимволы(
			ЗначениеКПП, 
			Представление, 
			ИмяРеквизита,
			Истина,
			ТекстОшибки)Тогда
			
			РезультатПроверки.ТекстОшибки = ТекстОшибки;

		ИначеЕсли НЕ ДокументооборотСКОКлиентСервер.ПроверитьКПП(ЗначениеКПП) И ЗначениеЗаполнено(ЗначениеКПП) Тогда
			
			РезультатПроверки.ТекстОшибки = Представление + НСтр("ru = ' должен состоять из 9 цифр';
																|en = ' должен состоять из 9 цифр'");
			РезультатПроверки.Пустой	  = Истина;
			
		КонецЕсли;
		
	КонецЕсли;

	УстановитьОтказ(Отказ, РезультатПроверки);
	
КонецФункции

Функция ПроверитьРегНомерПФР(ИмяРеквизита, Отказ)
	
	РезультатПроверки = ДокументооборотСКОКлиентСервер.РезультатПроверкиРеквизитов();
	РезультатПроверки.Поле = "Объект." + ИмяРеквизита;
	
	ЭтотОбъект[ИмяРеквизита] = СокрЛП(ЭтотОбъект[ИмяРеквизита]);
	ЗначениеРегНомераПФР = ЭтотОбъект[ИмяРеквизита];
	
	Представление = Строка(ЭтотОбъект.Метаданные().Реквизиты[ИмяРеквизита]);
	
	ИспользоватьРегНомерСФР = ДокументооборотСКОВызовСервера.СобытиеНаступилоИспользоватьРегНомерСФР();
	
	Если НЕ ДокументооборотСКОКлиентСервер.ПроверитьРегистрационныйНомерПФР(ЗначениеРегНомераПФР, Истина)
		И НЕ ДокументооборотСКОКлиентСервер.ПроверитьРегНомерСФР(ЗначениеРегНомераПФР) Тогда
		
		Если ИспользоватьРегНомерСФР Тогда
			РезультатПроверки.ТекстОшибки = Представление + НСтр("ru = ' должен состоять из 12 цифр (ХХХ-ХХХ-ХХХХХХ) или 10 цифр (ХХХХХХХХХХ)';
																|en = ' должен состоять из 12 цифр (ХХХ-ХХХ-ХХХХХХ) или 10 цифр (ХХХХХХХХХХ)'");
		Иначе
			РезультатПроверки.ТекстОшибки = Представление + НСтр("ru = ' должен состоять из 12 цифр (ХХХ-ХХХ-ХХХХХХ)';
																|en = ' должен состоять из 12 цифр (ХХХ-ХХХ-ХХХХХХ)'");
		КонецЕсли;
	КонецЕсли;
	
	УстановитьОтказ(Отказ, РезультатПроверки);
	
КонецФункции

Функция ПроверитьАдрес(Отказ, ЗначениеАдреса, Путь, НазваниеАдреса)
	
	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	РезультатПроверки = ДокументооборотСКОКлиентСервер.РезультатПроверкиРеквизитов();
	РезультатПроверки.Поле = Путь;
	
	Если НЕ ЗначениеЗаполнено(ЗначениеАдреса) Тогда 
		
		РезультатПроверки.ТекстОшибки = СтрШаблон(НСтр("ru = 'Укажите %1.';
														|en = 'Укажите %1.'"), НазваниеАдреса);
		РезультатПроверки.Пустой	  = Истина;
		
	КонецЕсли;

	УстановитьОтказ(Отказ, РезультатПроверки);
	
КонецФункции

Процедура ПроверитьСНИЛС(Отказ)
	
	ЭтоЮридическоеЛицо = РегламентированнаяОтчетностьВызовСервера.ЭтоЮридическоеЛицо(Организация);
	
	Если ЭтоЮридическоеЛицо Тогда
		Возврат;
	КонецЕсли;
	
	РезультатПроверки = ДокументооборотСКОКлиентСервер.РезультатПроверкиРеквизитов();
	РезультатПроверки.Поле = "Объект.СНИЛС";
	
	СНИЛСБезРазделителей = СНИЛСБезРазделителей(СНИЛС);
	
	Если НЕ ПустаяСтрока(СНИЛСБезРазделителей) Тогда
		Если НЕ ДокументооборотСКОКлиентСервер.ПроверитьСНИЛС(СНИЛС) Тогда
			РезультатПроверки.ТекстОшибки = НСтр("ru = 'Некорректно указан СНИЛС. Не соответствует маске ХХХ-ХХХ-ХХХ ХХ, где X - любая цифра';
												|en = 'Некорректно указан СНИЛС. Не соответствует маске ХХХ-ХХХ-ХХХ ХХ, где X - любая цифра'");
		ИначеЕсли НЕ ДокументооборотСКОКлиентСервер.ПроверитьСНИЛС(СНИЛС, Ложь, Истина) Тогда
			РезультатПроверки.ТекстОшибки = НСтр("ru = 'Некорректно указан СНИЛС. Не сошлось контрольное число (СНИЛС не существует)';
												|en = 'Некорректно указан СНИЛС. Не сошлось контрольное число (СНИЛС не существует)'");
		КонецЕсли;
	КонецЕсли;

	УстановитьОтказ(Отказ, РезультатПроверки);
	
КонецПроцедуры

Функция ПроверитьТелефон(Отказ)
	
	РезультатПроверки = ДокументооборотСКОКлиентСервер.РезультатПроверкиРеквизитов();
	РезультатПроверки.Поле = "Объект.Телефон";
	
	// Телефон
	ТелефонБезРазделителей = ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ТелефонМобильныйБезРазделителей(Телефон);
	
	Если ЗначениеЗаполнено(ТелефонБезРазделителей) Тогда
		Если НЕ ДокументооборотСКОКлиентСервер.ПроверитьЦифровойКодЗаданнойДлины(ТелефонБезРазделителей, 11, Истина) Тогда 
			РезультатПроверки.ТекстОшибки = НСтр("ru = 'Телефон должен иметь формат +7 XXX XXX-XX-XX';
												|en = 'Телефон должен иметь формат +7 XXX XXX-XX-XX'");
		КонецЕсли;
	КонецЕсли;
	
	УстановитьОтказ(Отказ, РезультатПроверки);
	
КонецФункции

Функция ПроверитьЭлПочту(Отказ)
	
	ТекстОшибки = "";
	
	РезультатПроверки = ДокументооборотСКОКлиентСервер.РезультатПроверкиРеквизитов();
	РезультатПроверки.Поле = "Объект.ЭлектроннаяПочта";
	
	// электронная почта
	ЭлектроннаяПочта = СокрЛП(ЭлектроннаяПочта);
	
	Если ЗначениеЗаполнено(ЭлектроннаяПочта) Тогда
		Если ДокументооборотСКОКлиентСервер.НайденыЗапрещенныеСимволы(
				ЭлектроннаяПочта, 
				НСтр("ru = 'Электронная почта ';
					|en = 'Электронная почта '"),
				"ЭлектроннаяПочтаДляПаролей",
				Истина,
				ТекстОшибки) Тогда
				
			РезультатПроверки.ТекстОшибки = ТекстОшибки;
			
		ИначеЕсли НЕ ОбщегоНазначенияКлиентСервер.АдресЭлектроннойПочтыСоответствуетТребованиям(ЭлектроннаяПочта) Тогда
				
			Если НЕ СтрНайти(ЭлектроннаяПочта, "@") Тогда
				РезультатПроверки.ТекстОшибки = НСтр("ru = 'Некорректно указана электронная почта. Отсутствует символ @';
													|en = 'Некорректно указана электронная почта. Отсутствует символ @'");
			Иначе 
				РезультатПроверки.ТекстОшибки = НСтр("ru = 'Электронная почта содержит некорректные сочетания символов';
													|en = 'Электронная почта содержит некорректные сочетания символов'");
			КонецЕсли;
				
		КонецЕсли;
	КонецЕсли;
	
	УстановитьОтказ(Отказ, РезультатПроверки);
	
КонецФункции

Функция СНИЛСБезРазделителей(СНИЛС)

	СНИЛСТолькоЦифры = СтрЗаменить(СНИЛС, "-","");
	СНИЛСТолькоЦифры = СтрЗаменить(СНИЛСТолькоЦифры, " ","");
	
	Возврат СНИЛСТолькоЦифры;

КонецФункции

Функция ПроверитьУчетку(Отказ)
	
	// Здесь хочется сделать проверку только для заявлений на подключение,
	// но для того, чтобы отправить заявление на отключение, тоже нужна учетка.
	// Поэтому проверяем для любого вида заявления.
	
	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	
	РезультатПроверки = ДокументооборотСКОКлиентСервер.РезультатПроверкиРеквизитов();
	РезультатПроверки.Поле = "Объект.Организация";
	
	УчетнаяЗапись = КонтекстЭДОСервер.УчетнаяЗаписьОрганизации(Организация);
	ЭтоРежимОблачной1СО = ДокументооборотСКОПовтИсп.ЭтоРежимОблачной1СО();
	
	Если НЕ ЭтоРежимОблачной1СО И НЕ ЗначениеЗаполнено(УчетнаяЗапись) И ДокументооборотСКОВызовСервера.ЗапоминаниеОшибок(,, Истина) = 0 Тогда
		РезультатПроверки.ТекстОшибки = НСтр("ru = 'Отправка заявления возможна только после подключения к 1С-Отчетности';
											|en = 'Отправка заявления возможна только после подключения к 1С-Отчетности'");
	КонецЕсли;

	УстановитьОтказ(Отказ, РезультатПроверки);
	
КонецФункции

Процедура УстановитьОтказ(Отказ, РезультатПроверки)
	
	Если ЗначениеЗаполнено(РезультатПроверки.ТекстОшибки) Тогда
		Отказ = Истина;
		ОбщегоНазначения.СообщитьПользователю(РезультатПроверки.ТекстОшибки,ЭтотОбъект,,РезультатПроверки.Поле);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецЕсли