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
	
	Если Не ЗначениеЗаполнено(Идентификатор) Тогда
		Идентификатор = СтрЗаменить(Новый УникальныйИдентификатор, "-", "");
	КонецЕсли;
	ДатаСоздания = ТекущаяДатаСеанса();
	
	Организация = Отправитель;
	ЗаполнитьНаименование();
	ЗаполнитьСодержание();
	Тип = Перечисления.ТипыПерепискиСКонтролирующимиОрганами.ПерепискаСПФР;
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	КонтекстЭДО = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	КонтекстЭДО.ПередЗаписьюОбъекта(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(СообщениеОснование)
	
	КонтекстЭДО = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	КонтекстЭДО.ОбработкаЗаполненияОбъекта(ЭтотОбъект, СообщениеОснование);
	
	ДатаСообщения = ТекущаяДатаСеанса();
	
	Если РегламентированнаяОтчетностьВызовСервера.ИспользуетсяОднаОрганизация() Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("Справочники.Организации");
		Организация = Модуль.ОрганизацияПоУмолчанию();
		Отправитель = Организация;
	КонецЕсли;
	
	Если ТипЗнч(СообщениеОснование) = Тип("Структура")
		И СообщениеОснование.Свойство("Отправитель")
		И ТипЗнч(СообщениеОснование.Отправитель) = Тип("СправочникСсылка.Организации") Тогда
		Организация = СообщениеОснование.Отправитель;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Идентификатор = Неопределено;
	ИдентификаторОснования = Неопределено;
	ДатаОтправки = Неопределено;
	ДатаСообщения = ТекущаяДатаСеанса();
	
	Статус = Перечисления.СтатусыПисем.Сохраненное;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ЕстьРеестр = Ложь;
	КоличествоНеЗаполненныхДокументов = 0;
	Для Каждого СтрокаТаблицы Из ЭлектронныеДокументы Цикл
		Если НРег(СтрокаТаблицы.Документ) = "реестр" Тогда
			Если ЗначениеЗаполнено(СтрокаТаблицы.Файл) Тогда
				ЕстьРеестр = Истина;
			КонецЕсли;
			Продолжить;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(СтрокаТаблицы.Файл) И ЗначениеЗаполнено(СтрокаТаблицы.Документ) Тогда
			ОбщегоНазначения.СообщитьПользователю(
				СтрШаблон(НСтр("ru = 'Добавьте файлы для документа ""%1""';
								|en = 'Добавьте файлы для документа ""%1""'"), СтрокаТаблицы.Документ),, 
				СтрШаблон("ТаблицаДокументов[%1].ФайлыПредставление", Формат(ЭлектронныеДокументы.Индекс(СтрокаТаблицы), "ЧГ=")),, 
				Отказ);
		КонецЕсли;
		Если Не ЗначениеЗаполнено(СтрокаТаблицы.Документ) Тогда
			ОбщегоНазначения.СообщитьПользователю(
				СтрШаблон(НСтр("ru = 'Заполните вид документа в строке %1';
								|en = 'Заполните вид документа в строке %1'"), ЭлектронныеДокументы.Индекс(СтрокаТаблицы) + 1),,
				СтрШаблон("ТаблицаДокументов[%1].Документ", Формат(ЭлектронныеДокументы.Индекс(СтрокаТаблицы), "ЧГ=")),, 
				Отказ);
		КонецЕсли;	
		Если Не ЗначениеЗаполнено(СтрокаТаблицы.Файл) ИЛИ НЕ ЗначениеЗаполнено(СтрокаТаблицы.Документ) Тогда
			КоличествоНеЗаполненныхДокументов = КоличествоНеЗаполненныхДокументов + 1;
		КонецЕсли;
	КонецЦикла;
	
	Если Не ЕстьРеестр И ЭлектронныеДокументы.Количество() <> 0 Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Добавьте реестр направляемых документов';
				|en = 'Добавьте реестр направляемых документов'"),,
			"РеестрДокументов",,
			Отказ);
	КонецЕсли;
	
	Если СтрДлина(СокрЛП(СтрЗаменить(ОрганПФРПоМестуНазначенияПенсии, "-", ""))) <> 6 Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Код органа СФР (бывш. ПФР) по месту назначения пенсии должен состоят из 6 цифр';
				|en = 'Код органа СФР (бывш. ПФР) по месту назначения пенсии должен состоят из 6 цифр'"),
			Ссылка, 
			"Объект.ОрганПФРПоМестуНазначенияПенсии",, Отказ);		
	КонецЕсли;
		
	Если Не ЗначениеЗаполнено(СокрЛП(СтрЗаменить(СтраховойНомерПФР, "-", ""))) Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Заполните СНИЛС';
				|en = 'Заполните СНИЛС'"),, "СтраховойНомерПФР",, Отказ);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(АдресРегистрации) Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Заполните адрес регистрации';
				|en = 'Заполните адрес регистрации'"),, "АдресРегистрации",, Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьНаименование()
	
	Наименование = СтрШаблон("Макет пенсионного дела (%1, %2)", Сотрудник, СтраховойНомерПФР);

КонецПроцедуры

Процедура ЗаполнитьСодержание()
	
	ШаблонПисьма = НСтр("ru = 'Направляем Вам макет пенсионного дела сотрудника:
                        |%1 (%2)
                        |
                        |Адрес регистрации: %3
                        |Контактный телефон: %4';
                        |en = 'Направляем Вам макет пенсионного дела сотрудника:
                        |%1 (%2)
                        |
                        |Адрес регистрации: %3
                        |Контактный телефон: %4'");
	
	Содержание = СтрШаблон(
		ШаблонПисьма, 
		ФИО, 
		?(Стаж = Перечисления.ВидыСтажаДляНазначенияПенсии.ЗаВыслугуЛет, "льготные условия", "общие условия"),
		АдресРегистрации,
		Телефон);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли