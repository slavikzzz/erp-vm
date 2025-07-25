#Область НастройкиДоступаКРесурсуСАктуальнымиСведениями

Процедура ПродолжитьПослеПроверкиПодключенияКИПП(ОписаниеОповещенияДляЗавершения)
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОписаниеОповещенияДляЗавершения", ОписаниеОповещенияДляЗавершения);
	Оповещение = Новый ОписаниеОповещения("ПродолжитьПослеПроверкиПодключенияКИППЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	Форма = ОписаниеОповещенияДляЗавершения.ДополнительныеПараметры.КонтекстФормы;
	
	Если Форма <> Неопределено Тогда
		Форма.ОписаниеОповещенияПослеПроверкиПодключенияКИПП = Оповещение;
		Форма.ПодключитьОбработчикОжидания("Подключаемый_ПроверитьПодключениеИнтернетПоддержки", 1, Истина);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПродолжитьПослеПроверкиПодключенияКИППЗавершение(Результат, ВходящийКонтекст) Экспорт
	
	ОписаниеОповещенияДляЗавершения = ВходящийКонтекст.ОписаниеОповещенияДляЗавершения;
	
	ПроверкаВыполнена = Ложь;
	
	Если Результат.Выполнено И Результат.ВыполнениеРазрешено Тогда
		ПроверкаВыполнена = Истина;
	ИначеЕсли Результат.Выполнено И НЕ Результат.ВыполнениеРазрешено Тогда
		ПроверкаВыполнена = Ложь;
	ИначеЕсли НЕ Результат.Выполнено Тогда
		ОнлайнСервисыРегламентированнойОтчетностиВызовСервера.ЗаписатьВЖурналРегистрации("УровеньЖурналаРегистрации.Ошибка",
			НСтр("ru = 'При проверке доступа к интернет-поддержке пользователя возникла неизвестная ошибка.';
				|en = 'При проверке доступа к интернет-поддержке пользователя возникла неизвестная ошибка.'"));
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ОписаниеОповещенияДляЗавершения, ПроверкаВыполнена);
	
КонецПроцедуры

Процедура ЗапроситьПараметрыПрокси(Знач ОписаниеОповещенияДляПродолжения = Неопределено) Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОписаниеОповещенияДляПродолжения", ОписаниеОповещенияДляПродолжения);
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗапроситьПараметрыПроксиЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ОткрытьФорму("ОбщаяФорма.ПараметрыПроксиСервера",,,,,, ОписаниеОповещения);

КонецПроцедуры

Процедура ЗапроситьПараметрыПроксиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ОписаниеОповещенияДляПродолжения = ДополнительныеПараметры.ОписаниеОповещенияДляПродолжения;
	Если ОписаниеОповещенияДляПродолжения <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ОписаниеОповещенияДляПродолжения, Результат);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

Процедура АктуализироватьСлужебнуюИнформациюМеханизмаОнлайнСервисовРОПриНеобходимости(Форма, ПараметрыИНастройки = Неопределено) Экспорт
	
	// в режиме сервиса данные актуализируются через поставляемые данные
	Если СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента().РазделениеВключено Тогда 
		Возврат;
	КонецЕсли;
	
	Если ПараметрыИНастройки = Неопределено Тогда
		ПараметрыИНастройки =
			ОнлайнСервисыРегламентированнойОтчетностиВызовСервера.ПолучитьПараметрыИНастройкиМеханизмаОнлайнСервисовРО();
	КонецЕсли;
	
	НастройкиМеханизмаОнлайнСервисов = ПараметрыИНастройки.НастройкиМеханизмаОнлайнСервисов;
	ЕстьПравоИзмененияРегистраРесурсов = ПараметрыИНастройки.ЕстьПравоИзмененияРегистраРесурсов;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("КонтекстФормы", Форма);
	ДополнительныеПараметры.Вставить("НастройкиМеханизмаОнлайнСервисов", НастройкиМеханизмаОнлайнСервисов);
	ДополнительныеПараметры.Вставить("ЕстьПравоИзмененияРегистраРесурсов", ЕстьПравоИзмененияРегистраРесурсов);
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"АктуализироватьСлужебнуюИнформациюМеханизмаОнлайнСервисовРОПриНеобходимостиПродолжение",
		ЭтотОбъект, ДополнительныеПараметры);
	
	// Если механизм выключен, то прервемся.
	Если НЕ НастройкиМеханизмаОнлайнСервисов.Использовать Тогда
		Возврат;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ОписаниеОповещения, Истина);
	
КонецПроцедуры

Процедура АктуализироватьСлужебнуюИнформациюМеханизмаОнлайнСервисовРОПриНеобходимостиПродолжение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Истина Тогда
		Возврат;
	КонецЕсли;
	
	ЕстьПравоИзмененияРегистраРесурсов = Неопределено;
	ДополнительныеПараметры.Свойство("ЕстьПравоИзмененияРегистраРесурсов", ЕстьПравоИзмененияРегистраРесурсов);
	
	Если ЕстьПравоИзмененияРегистраРесурсов = Неопределено Тогда
		ЕстьПравоИзмененияРегистраРесурсов =
			ОнлайнСервисыРегламентированнойОтчетностиВызовСервера.ЕстьПравоИзмененияРегистраРесурсыМеханизмаОнлайнСервисовРО();
	КонецЕсли;
	
	// Если нет доступа к регистру, то не выполняем актуализацию
	Если НЕ ЕстьПравоИзмененияРегистраРесурсов Тогда
		Возврат;
	КонецЕсли;
	
	НастройкиМеханизмаОнлайнСервисов = ДополнительныеПараметры.НастройкиМеханизмаОнлайнСервисов;
	
	ОписаниеОповещенияДляЗавершения = Новый ОписаниеОповещения("АктуализироватьСлужебнуюИнформациюМеханизмаОнлайнСервисовРОПриНеобходимостиЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	Если НастройкиМеханизмаОнлайнСервисов.АвтоматическиПодключатьФормыРО = Истина
		И ИнтернетПоддержкаПользователейКлиент.ДоступноПодключениеИнтернетПоддержки()
		И НЕ СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента().РазделениеВключено Тогда
		ПродолжитьПослеПроверкиПодключенияКИПП(ОписаниеОповещенияДляЗавершения);
	Иначе
		ВыполнитьОбработкуОповещения(ОписаниеОповещенияДляЗавершения, Ложь);
	КонецЕсли;
	
КонецПроцедуры

Процедура АктуализироватьСлужебнуюИнформациюМеханизмаОнлайнСервисовРОПриНеобходимостиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Форма = ДополнительныеПараметры.КонтекстФормы;
	
	УникальныйИдентификаторФормы = ?(Форма <> Неопределено, Форма.УникальныйИдентификатор, Неопределено);
	
	РезультатВыполненияЗадания = ОнлайнСервисыРегламентированнойОтчетностиВызовСервера.ЗапуститьФоновоеЗаданиеАктуализироватьСлужебнуюИнформациюМеханизмаОнлайнСервисовРО(УникальныйИдентификаторФормы, Результат);
	
	Если НЕ СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента().РазделениеВключено И ИнтернетПоддержкаПользователейКлиент.ДоступноПодключениеИнтернетПоддержки() И Форма <> Неопределено Тогда
		
		Форма.АдресХранилищаМОС = РезультатВыполненияЗадания.АдресРезультата;
		Форма.ИдентификаторЗаданияМОС = РезультатВыполненияЗадания.ИдентификаторЗадания;
		
		Если РезультатВыполненияЗадания.Статус = "Выполнено" Тогда
			Форма.ПоказатьРезультатПроверкиОбновленияИнформацииМОС();
		ИначеЕсли ЗначениеЗаполнено(РезультатВыполненияЗадания.ИдентификаторЗадания) Тогда
			ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Форма);
			ПараметрыОжидания.ВыводитьСообщения = Истина;
			ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
			ОписаниеОповещения = Новый ОписаниеОповещения("ПоказатьРезультатПроверкиОбновленияИнформацииМОС", Форма.ЭтотОбъект);
			ДлительныеОперацииКлиент.ОжидатьЗавершение(РезультатВыполненияЗадания, ОписаниеОповещения, ПараметрыОжидания);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#Область МеханизмБлокировок

Процедура ПроверкаОнлайнБлокировки(ВыполняемоеОповещение, Объект, БлокируемаяФункция = "И") Экспорт
	
	Если НЕ ОнлайнСервисыРегламентированнойОтчетностиВызовСервера.МеханизмОнлайнСервисовВключен() Тогда
		ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, Истина);
		Возврат;
	КонецЕсли;
	
	ВерсияОтчета = ПолучитьКраткуюВерсиюОтчета(Объект);
	ВерсияВыпуска = ВРЕГ(?(ЗначениеЗаполнено(ВерсияОтчета), ВерсияОтчета, ОнлайнСервисыРегламентированнойОтчетностиВызовСервера.ИнформацияОПрограмме().ВерсияКонфигурации));
	
	ИДОтчета = ИДОтчета(Объект);
	
	СтруктураРеквизитовФормы = Объект.СтруктураРеквизитовФормы;
	Если ТипЗнч(Объект) = Тип("ФормаКлиентскогоПриложения") Тогда
		Если РегламентированнаяОтчетностьКлиентСервер.СвойствоОпределено(СтруктураРеквизитовФормы, "мВыбраннаяФорма") И ЗначениеЗаполнено(СтруктураРеквизитовФормы.мВыбраннаяФорма) Тогда
			ИДФормы = ВРЕГ(СтруктураРеквизитовФормы.мВыбраннаяФорма);
		ИначеЕсли РегламентированнаяОтчетностьКлиентСервер.СвойствоОпределено(СтруктураРеквизитовФормы, "мСохраненныйДок") И ЗначениеЗаполнено(СтруктураРеквизитовФормы.мСохраненныйДок) 
				И ЗначениеЗаполнено(СтруктураРеквизитовФормы.мСохраненныйДок.ВыбраннаяФорма) Тогда
			ИДФормы = ВРЕГ(СтруктураРеквизитовФормы.мСохраненныйДок.ВыбраннаяФорма);
		Иначе
			ИДФормы = Неопределено;
		КонецЕсли;
	Иначе
		ИДФормы = Неопределено;
	КонецЕсли;
	
	СведенияПоБлокировке = ОнлайнСервисыРегламентированнойОтчетностиВызовСервера.ПроверкаОнлайнБлокировкиСервер(ВерсияВыпуска, ИДОтчета, ИДФормы, БлокируемаяФункция);
	
	// Если проверка показала, что блокировать не нужно
	// либо блокируется отправка, но модуль уже обновлен на тот, который содержит исправление ошибки,
	// то предупреждения не показываем
	Если СведенияПоБлокировке.РезультатПроверки 
		ИЛИ БлокируемаяФункция = "О" И ВерсияМодуляВБазеСодержитИсправление(СведенияПоБлокировке.ВерсияМодуляДокументооборотаСИсправлениемОшибки) = Истина Тогда
		
		// Для отчетов статистики при открытии сразу же проверяем и актуальность выгрузки
		Если СведенияПоБлокировке.РезультатПроверки 
			И БлокируемаяФункция = "И" 
			И СтрНачинаетсяС(Строка(ИДОтчета), "РЕГЛАМЕНТИРОВАННЫЙОТЧЕТСТАТИСТИКА") Тогда 
			
			СведенияПоБлокировкеВыгрузки = ОнлайнСервисыРегламентированнойОтчетностиВызовСервера.ПроверкаОнлайнБлокировкиСервер(ВерсияВыпуска, ИДОтчета, ИДФормы, "В");
			
			Если СведенияПоБлокировкеВыгрузки.РезультатПроверки Тогда 
				ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, Истина);
			Иначе 
				ДополнительныеПараметры = Новый Структура();
				ДополнительныеПараметры.Вставить("ВыполняемоеОповещение", ВыполняемоеОповещение);
				ОписаниеОповещения = Новый ОписаниеОповещения("ПроверкаОнлайнБлокировкиЗавершение", ЭтотОбъект, ДополнительныеПараметры);
				ПоказатьУведомлениеОБлокировке(ОписаниеОповещения, Объект, СведенияПоБлокировкеВыгрузки);
			КонецЕсли;
			Возврат;
		КонецЕсли;
		
		ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, Истина);
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ВыполняемоеОповещение", ВыполняемоеОповещение);
	ОписаниеОповещения = Новый ОписаниеОповещения("ПроверкаОнлайнБлокировкиЗавершение", ЭтотОбъект, ДополнительныеПараметры);

	// показываем диалог пользователю
	ПоказатьУведомлениеОБлокировке(ОписаниеОповещения, Объект, СведенияПоБлокировке);

КонецПроцедуры

Функция ВерсияМодуляВБазеСодержитИсправление(ВерсияМодуляДокументооборотаСИсправлениемОшибки) Экспорт
	
	Возврат ОнлайнСервисыРегламентированнойОтчетностиВызовСервера.ВерсияМодуляВБазеСодержитИсправление(
		ВерсияМодуляДокументооборотаСИсправлениемОшибки);	
	
КонецФункции

Процедура ПроверкаОнлайнБлокировкиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ВыполняемоеОповещение, Результат);
	
КонецПроцедуры

Процедура ПроверкаФормыПоПериодуПрименения(ВыполняемоеОповещение, Форма) Экспорт
	
	// если механизм выключен, то прервем проверку
	Если НЕ ОнлайнСервисыРегламентированнойОтчетностиВызовСервера.МеханизмОнлайнСервисовВключен() Тогда
		ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, Истина);
		Возврат;
	КонецЕсли;
	
	// имя отчета
	ИДОтчета = ИДОтчета(Форма);
	
	// получаем период отчета
	СтруктураРеквизитовФормы = Форма.СтруктураРеквизитовФормы;
	
	Если НЕ РегламентированнаяОтчетностьКлиентСервер.СвойствоОпределено(СтруктураРеквизитовФормы, "мДатаНачалаПериодаОтчета") 
			ИЛИ НЕ РегламентированнаяОтчетностьКлиентСервер.СвойствоОпределено(СтруктураРеквизитовФормы, "мДатаКонцаПериодаОтчета") Тогда
		ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, Истина);
		Возврат;
	КонецЕсли;
	ДатаКонцаПериодаОтчета = СтруктураРеквизитовФормы.мДатаКонцаПериодаОтчета;
	
	// получаем имя формы
	ИмяФормы = ИмяФормы(СтруктураРеквизитовФормы);
	Если НЕ ЗначениеЗаполнено(ИмяФормы) Тогда
		ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, Истина);
		Возврат;
	КонецЕсли;
	
	СведенияПоБлокировке = ОнлайнСервисыРегламентированнойОтчетностиВызовСервера.ПроверкаФормыПоПериодуПримененияСервер(
		СтруктураРеквизитовФормы, ДатаКонцаПериодаОтчета, ИмяФормы, ИДОтчета);
		
	// Если проверка показала, что блокировать не нужно, то предупреждения не показываем
	Если СведенияПоБлокировке.РезультатПроверки Тогда
		ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, Истина);
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ВыполняемоеОповещение", ВыполняемоеОповещение);
	ОписаниеОповещения = Новый ОписаниеОповещения("ПроверкаФормыПоПериодуПримененияЗавершение", ЭтотОбъект, ДополнительныеПараметры);

	// показываем диалог пользователю
	ПоказатьУведомлениеОБлокировкеУтвержденнойФормы(ОписаниеОповещения, Форма, СведенияПоБлокировке);
	
КонецПроцедуры

Процедура ПроверкаФормыПоПериодуПримененияЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ВыполняемоеОповещение, Результат);
	
КонецПроцедуры

Процедура ПроверкаФорматаПоПериодуПрименения(ВыполняемоеОповещение, Форма) Экспорт
	
	// если механизм выключен, то прервем проверку
	Если НЕ ОнлайнСервисыРегламентированнойОтчетностиВызовСервера.МеханизмОнлайнСервисовВключен() Тогда
		ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, Истина);
		Возврат;
	КонецЕсли;
	
	// имя отчета
	ИДОтчета = ИДОтчета(Форма);
	
	// получаем период отчета
	СтруктураРеквизитовФормы = Форма.СтруктураРеквизитовФормы;
	
	Если НЕ РегламентированнаяОтчетностьКлиентСервер.СвойствоОпределено(СтруктураРеквизитовФормы, "мДатаНачалаПериодаОтчета") 
			ИЛИ НЕ РегламентированнаяОтчетностьКлиентСервер.СвойствоОпределено(СтруктураРеквизитовФормы, "мДатаКонцаПериодаОтчета") Тогда
		ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, Истина);
		Возврат;
	КонецЕсли;
	ДатаКонцаПериодаОтчета = СтруктураРеквизитовФормы.мДатаКонцаПериодаОтчета;
	
	// получаем имя формы
	ИмяФормы = ИмяФормы(СтруктураРеквизитовФормы);
	Если НЕ ЗначениеЗаполнено(ИмяФормы) Тогда
		ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, Истина);
		Возврат;
	КонецЕсли;
	ИмяФормы = ВРЕГ(ИмяФормы);
	
	СведенияПоБлокировке = ОнлайнСервисыРегламентированнойОтчетностиВызовСервера.ПроверкаФорматаПоПериодуПримененияСервер(
		СтруктураРеквизитовФормы, ДатаКонцаПериодаОтчета, ИмяФормы, ИДОтчета);
		
	// Если проверка показала, что блокировать не нужно, то предупреждения не показываем
	Если СведенияПоБлокировке.РезультатПроверки Тогда
		ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, Истина);
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ВыполняемоеОповещение", ВыполняемоеОповещение);
	ОписаниеОповещения = Новый ОписаниеОповещения("ПроверкаФорматаПоПериодуПримененияЗавершение", ЭтотОбъект, ДополнительныеПараметры);

	// показываем диалог пользователю
	ПоказатьУведомлениеОБлокировкеУтвержденногоФормата(ОписаниеОповещения, Форма, СведенияПоБлокировке);
	
КонецПроцедуры

Процедура ПроверкаФорматаПоПериодуПримененияЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ВыполняемоеОповещение, Результат);
	
КонецПроцедуры

#Область ОткрытиеФормУведомлений

Процедура ПоказатьУведомлениеОБлокировке(ВыполняемоеОповещение, Объект, СвойстваБлокировки)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗапретНаПродолжение", 								СвойстваБлокировки.Жесткая);
	ПараметрыФормы.Вставить("ТекстЗаголовок", 									ПредставлениеОбъектаБлокировки(Объект));
	ПараметрыФормы.Вставить("ТекстПодробнее", 									СвойстваБлокировки.Комментарий);
	ПараметрыФормы.Вставить("БлокируемаяФункция", 								СвойстваБлокировки.Функция);
	ПараметрыФормы.Вставить("БлокировкаФормыИЛИФормата", 						Ложь);
	ПараметрыФормы.Вставить("ВерсияМодуляДокументооборотаСИсправлениемОшибки", 	СвойстваБлокировки.ВерсияМодуляДокументооборотаСИсправлениемОшибки);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ВыполняемоеОповещение", ВыполняемоеОповещение);
	ОписаниеОповещения = Новый ОписаниеОповещения("ПоказатьУведомлениеОБлокировкеЗавершение", ЭтотОбъект, ДополнительныеПараметры);

	Если Объект.Модифицированность Тогда
		// Открываем с указанием владельца
		ОткрытьФорму("Обработка.ОнлайнСервисыРегламентированнойОтчетности.Форма.УведомлениеОБлокировкеФормыИЛИФормата", ПараметрыФормы,Объект,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	Иначе
		// Открываем без указания владельца
		ОткрытьФорму("Обработка.ОнлайнСервисыРегламентированнойОтчетности.Форма.УведомлениеОБлокировкеФормыИЛИФормата", ПараметрыФормы,,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПоказатьУведомлениеОБлокировкеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ВыполняемоеОповещение, Результат);
	
КонецПроцедуры

Процедура ПоказатьУведомлениеОБлокировкеУтвержденнойФормы(ВыполняемоеОповещение, Объект, СведенияПоБлокировке) Экспорт
	
	ПараметрыФормы = Новый Структура; 
	ПараметрыФормы.Вставить("ЗапретНаПродолжение", 								СведенияПоБлокировке.Жесткая);
	ПараметрыФормы.Вставить("ТекстЗаголовок", 									СведенияПоБлокировке.ТекстЗаголовок);
	ПараметрыФормы.Вставить("ТекстПодробнее", 									СведенияПоБлокировке.ТекстПодробнее);
	ПараметрыФормы.Вставить("ТекстИспользуйте", 								СведенияПоБлокировке.ТекстИспользуйте);
	ПараметрыФормы.Вставить("БлокировкаФормы", 									Истина);
	ПараметрыФормы.Вставить("БлокировкаФормыИЛИФормата", 						Истина);
	ПараметрыФормы.Вставить("ВерсияМодуляДокументооборотаСИсправлениемОшибки",	"");
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ВыполняемоеОповещение", ВыполняемоеОповещение);
	ОписаниеОповещения = Новый ОписаниеОповещения("ПоказатьУведомлениеОБлокировкеУтвержденнойФормыЗавершение", ЭтотОбъект, ДополнительныеПараметры);

	ОткрытьФорму("Обработка.ОнлайнСервисыРегламентированнойОтчетности.Форма.УведомлениеОБлокировкеФормыИЛИФормата", ПараметрыФормы,,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

Процедура ПоказатьУведомлениеОБлокировкеУтвержденнойФормыЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ВыполняемоеОповещение, ?(Результат = Неопределено, Ложь, Результат));
	
КонецПроцедуры

Процедура ПоказатьУведомлениеОБлокировкеУтвержденногоФормата(ВыполняемоеОповещение, Объект, СведенияПоБлокировке) Экспорт
	
	ПараметрыФормы = Новый Структура; 
	ПараметрыФормы.Вставить("ЗапретНаПродолжение", 								СведенияПоБлокировке.Жесткая);
	ПараметрыФормы.Вставить("ТекстЗаголовок", 									СведенияПоБлокировке.ТекстЗаголовок);
	ПараметрыФормы.Вставить("ТекстПодробнее", 									СведенияПоБлокировке.ТекстПодробнее);
	ПараметрыФормы.Вставить("ТекстИспользуйте", 								СведенияПоБлокировке.ТекстИспользуйте);
	ПараметрыФормы.Вставить("БлокировкаФормы", 									Ложь);
	ПараметрыФормы.Вставить("БлокировкаФормыИЛИФормата", 						Истина);
	ПараметрыФормы.Вставить("ВерсияМодуляДокументооборотаСИсправлениемОшибки",	"");
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ВыполняемоеОповещение", ВыполняемоеОповещение);
	ОписаниеОповещения = Новый ОписаниеОповещения("ПоказатьУведомлениеОБлокировкеУтвержденногоФорматаЗавершение", ЭтотОбъект, ДополнительныеПараметры);

	ОткрытьФорму("Обработка.ОнлайнСервисыРегламентированнойОтчетности.Форма.УведомлениеОБлокировкеФормыИЛИФормата", ПараметрыФормы,,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

Процедура ПоказатьУведомлениеОБлокировкеУтвержденногоФорматаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ВыполняемоеОповещение, Результат);
	
КонецПроцедуры

Процедура ОткрытьФормуДоступныхОбновленийРО() Экспорт
	
	ОткрытьФорму("Обработка.ОнлайнСервисыРегламентированнойОтчетности.Форма.ДоступныеОбновленияРегламентированнойОтчетности");
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СобытияРегламентированныхОтчетов

// Параметры:
//  ВыполняемоеОповещение - ОписаниеОповещения - Описание оповещения, которое будет вызвано после открытия формы регламентированного отчета
//                                               В качестве результата описания оповещения передается булевская переменная.
//                                               Если Истина - форму нужно закрыть.
//  Форма - ФормаКлиентскогоПриложения - форма, из которой вызывается функция.
//  Отказ - Булево - значение необходимости отказа от продолжения работы с отчетом.
//

/////////////////////////////////////////////////////////////
// ВНИМАНИЕ!!! 
// Не удалять метод. Используется в 1С:УП Калуги Астрал
/////////////////////////////////////////////////////////////

Процедура ПередОткрытиемФормыРегламентированногоОтчета(ВыполняемоеОповещение, Форма, Отказ) Экспорт
	
	Если ТипЗнч(Форма) = Тип("ФормаКлиентскогоПриложения") Тогда
		СтруктураРеквизитовФормы = Форма.СтруктураРеквизитовФормы;
		Если РегламентированнаяОтчетностьКлиентСервер.СвойствоОпределено(СтруктураРеквизитовФормы, "Организация")
			И ЗначениеЗаполнено(СтруктураРеквизитовФормы.Организация) Тогда
			ПараметрыПриложения["БРО.ТекущаяОрганизация"] = СтруктураРеквизитовФормы.Организация;
		КонецЕсли;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ВыполняемоеОповещение", ВыполняемоеОповещение);
	ДополнительныеПараметры.Вставить("Форма", Форма);
	ДополнительныеПараметры.Вставить("Отказ", Отказ);
	
	ПередОткрытиемФормыРегламентированногоОтчета_ПроверкаОнлайнБлокировки(ДополнительныеПараметры);
КонецПроцедуры

Процедура ПередОткрытиемФормыРегламентированногоОтчета_ПроверкаОнлайнБлокировки(ДополнительныеПараметры)
	Форма = ДополнительныеПараметры.Форма;
	ОписаниеОповещения = Новый ОписаниеОповещения("ПередОткрытиемФормыРегламентированногоОтчетаПродолжение", ЭтотОбъект, ДополнительныеПараметры);
	ПроверкаОнлайнБлокировки(ОписаниеОповещения, Форма);
КонецПроцедуры

Процедура ПередОткрытиемФормыРегламентированногоОтчетаПродолжение(Результат, ДополнительныеПараметры) Экспорт
	
	ВыполняемоеОповещение 	= ДополнительныеПараметры.ВыполняемоеОповещение;
	Форма 					= ДополнительныеПараметры.Форма;
	Отказ 					= ДополнительныеПараметры.Отказ;
	
	Если НЕ Результат Тогда
		Отказ = Истина;
	КонецЕсли;

	// ПроверкаФормыПоПериодуПрименения
	НовыеДополнительныеПараметры = Новый Структура();
	НовыеДополнительныеПараметры.Вставить("ВыполняемоеОповещение", ВыполняемоеОповещение);
	НовыеДополнительныеПараметры.Вставить("Отказ", Отказ);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПередОткрытиемФормыРегламентированногоОтчетаЗавершение", ЭтотОбъект, НовыеДополнительныеПараметры);
	
	ПроверкаФормыПоПериодуПрименения(ОписаниеОповещения, Форма);
	
КонецПроцедуры

Процедура ПередОткрытиемФормыРегламентированногоОтчетаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ВыполняемоеОповещение 	= ДополнительныеПараметры.ВыполняемоеОповещение;
	Отказ 					= ДополнительныеПараметры.Отказ;
	
	Если НЕ Результат Тогда
		Отказ = Истина;
	КонецЕсли;

	ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, Отказ);
	
КонецПроцедуры

/////////////////////////////////////////////////////////////
// ВНИМАНИЕ!!! 
// Не удалять метод. Используется в 1С:УП Калуги Астрал
/////////////////////////////////////////////////////////////

Процедура ПередПечатьюРегламентированногоОтчета(ВыполняемоеОповещение, Форма, Отказ) Экспорт
	
	// ПроверкаОнлайнБлокировки
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ВыполняемоеОповещение", ВыполняемоеОповещение);
	ДополнительныеПараметры.Вставить("Отказ", Отказ);
	ОписаниеОповещения = Новый ОписаниеОповещения("ПередПечатьюРегламентированногоОтчетаЗавершение", ЭтотОбъект, ДополнительныеПараметры);
			
	ПроверкаОнлайнБлокировки(ОписаниеОповещения, Форма, "П");
	
КонецПроцедуры

Процедура ПередПечатьюРегламентированногоОтчетаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ВыполняемоеОповещение 	= ДополнительныеПараметры.ВыполняемоеОповещение;
	Отказ 					= ДополнительныеПараметры.Отказ;
	
	Если НЕ Результат Тогда
		Отказ = Истина;
	КонецЕсли;

	ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, Отказ);
	
КонецПроцедуры

Процедура ПередПечатьюМЧБРегламентированногоОтчета(ВыполняемоеОповещение, Форма, Отказ) Экспорт
	
	// ПроверкаОнлайнБлокировки
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ВыполняемоеОповещение", ВыполняемоеОповещение);
	ДополнительныеПараметры.Вставить("Отказ", Отказ);
	ОписаниеОповещения = Новый ОписаниеОповещения("ПередПечатьюМЧБРегламентированногоОтчетаЗавершение", ЭтотОбъект, ДополнительныеПараметры);
			
	ПроверкаОнлайнБлокировки(ОписаниеОповещения, Форма, "ПВ");
	
КонецПроцедуры

Процедура ПередПечатьюМЧБРегламентированногоОтчетаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ВыполняемоеОповещение 	= ДополнительныеПараметры.ВыполняемоеОповещение;
	Отказ 					= ДополнительныеПараметры.Отказ;
	
	Если НЕ Результат Тогда
		Отказ = Истина;
	КонецЕсли;

	ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, Отказ);
	
КонецПроцедуры

Процедура ПередВыгрузкойРегламентированногоОтчета(ВыполняемоеОповещение, Форма, Отказ) Экспорт
	
	// ПроверкаОнлайнБлокировки
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ВыполняемоеОповещение", ВыполняемоеОповещение);
	ДополнительныеПараметры.Вставить("Форма", Форма);
	ДополнительныеПараметры.Вставить("Отказ", Отказ);
	ОписаниеОповещения = Новый ОписаниеОповещения("ПередВыгрузкойРегламентированногоОтчетаПродолжение", ЭтотОбъект, ДополнительныеПараметры);
	
	ПроверкаОнлайнБлокировки(ОписаниеОповещения, Форма, "В");
	
КонецПроцедуры

Процедура ПередВыгрузкойРегламентированногоОтчетаПродолжение(Результат, ДополнительныеПараметры) Экспорт
	
	ВыполняемоеОповещение 	= ДополнительныеПараметры.ВыполняемоеОповещение;
	Форма 					= ДополнительныеПараметры.Форма;
	Отказ 					= ДополнительныеПараметры.Отказ;
	
	Если Результат = Неопределено ИЛИ НЕ Результат Тогда
		Отказ = Истина;
	КонецЕсли;
	
	// ПроверкаФорматаПоПериодуПрименения
	НовыеДополнительныеПараметры = Новый Структура();
	НовыеДополнительныеПараметры.Вставить("ВыполняемоеОповещение", ВыполняемоеОповещение);
	НовыеДополнительныеПараметры.Вставить("Отказ", Отказ);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПередВыгрузкойРегламентированногоОтчетаЗавершение", ЭтотОбъект, НовыеДополнительныеПараметры);
	
	ПроверкаФорматаПоПериодуПрименения(ОписаниеОповещения, Форма);
	
КонецПроцедуры

Процедура ПередВыгрузкойРегламентированногоОтчетаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ВыполняемоеОповещение 	= ДополнительныеПараметры.ВыполняемоеОповещение;
	Отказ 					= ДополнительныеПараметры.Отказ;
	
	Если Результат = Неопределено ИЛИ НЕ Результат Тогда
		Отказ = Истина;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, Отказ);
	
КонецПроцедуры

Процедура ПередЗагрузкойРегламентированногоОтчета(ВыполняемоеОповещение, Форма, Отказ) Экспорт
	
	// ПроверкаОнлайнБлокировки
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ВыполняемоеОповещение", ВыполняемоеОповещение);
	ДополнительныеПараметры.Вставить("Форма", Форма);
	ДополнительныеПараметры.Вставить("Отказ", Отказ);
	ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗагрузкойРегламентированногоОтчетаПродолжение", ЭтотОбъект, ДополнительныеПараметры);
	
	ПроверкаОнлайнБлокировки(ОписаниеОповещения, Форма, "ЗГ");
	
КонецПроцедуры

Процедура ПередЗагрузкойРегламентированногоОтчетаПродолжение(Результат, ДополнительныеПараметры) Экспорт
	
	ВыполняемоеОповещение = ДополнительныеПараметры.ВыполняемоеОповещение;
	Форма                 = ДополнительныеПараметры.Форма;
	Отказ                 = ДополнительныеПараметры.Отказ;
	
	Если Результат = Неопределено ИЛИ НЕ Результат Тогда
		Отказ = Истина;
	КонецЕсли;
	
	// ПроверкаФорматаПоПериодуПрименения
	НовыеДополнительныеПараметры = Новый Структура();
	НовыеДополнительныеПараметры.Вставить("ВыполняемоеОповещение", ВыполняемоеОповещение);
	НовыеДополнительныеПараметры.Вставить("Отказ", Отказ);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗагрузкойРегламентированногоОтчетаЗавершение", ЭтотОбъект, НовыеДополнительныеПараметры);
	
	ПроверкаФорматаПоПериодуПрименения(ОписаниеОповещения, Форма);
	
КонецПроцедуры

Процедура ПередЗагрузкойРегламентированногоОтчетаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Отказ                 = ДополнительныеПараметры.Отказ;
	ВыполняемоеОповещение = ДополнительныеПараметры.ВыполняемоеОповещение;
	
	Если Результат = Неопределено ИЛИ НЕ Результат Тогда
		Отказ = Истина;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, Отказ);
	
КонецПроцедуры

Процедура ПередЗаполнениемРегламентированногоОтчета(ВыполняемоеОповещение, Форма, Отказ) Экспорт
	
	// ПроверкаОнлайнБлокировки
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ВыполняемоеОповещение", ВыполняемоеОповещение);
	ДополнительныеПараметры.Вставить("Отказ", Отказ);
	ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗаполнениемРегламентированногоОтчетаЗавершение", ЭтотОбъект, ДополнительныеПараметры);
			
	ПроверкаОнлайнБлокировки(ОписаниеОповещения, Форма, "З");
	
КонецПроцедуры

Процедура ПередЗаполнениемРегламентированногоОтчетаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ВыполняемоеОповещение 	= ДополнительныеПараметры.ВыполняемоеОповещение;
	Отказ 					= ДополнительныеПараметры.Отказ;
	
	Если НЕ Результат Тогда
		Отказ = Истина;
	КонецЕсли;

	ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, Отказ);
	
КонецПроцедуры

Процедура ПередОтправкойРегламентированногоОтчета(ВыполняемоеОповещение, Форма, Отказ) Экспорт
	
	// ПроверкаОнлайнБлокировки
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ВыполняемоеОповещение", ВыполняемоеОповещение);
	ДополнительныеПараметры.Вставить("Отказ", Отказ);
	ОписаниеОповещения = Новый ОписаниеОповещения("ПередОтправкойРегламентированногоОтчетаЗавершение", ЭтотОбъект, ДополнительныеПараметры);
			
	ПроверкаОнлайнБлокировки(ОписаниеОповещения, Форма, "О");
	
КонецПроцедуры

Процедура ПередОтправкойРегламентированногоОтчетаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ВыполняемоеОповещение 	= ДополнительныеПараметры.ВыполняемоеОповещение;
	Отказ 					= ДополнительныеПараметры.Отказ;
	
	Если Результат <> Истина Тогда
		Отказ = Истина;
	КонецЕсли;

	ВыполнитьОбработкуОповещения(ВыполняемоеОповещение, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ИмяФормы(СтруктураРеквизитовФормы)
	
	ИмяФормы = Неопределено;
	Если НЕ РегламентированнаяОтчетностьКлиентСервер.СвойствоОпределено(СтруктураРеквизитовФормы, "мВыбраннаяФорма") 
			И НЕ РегламентированнаяОтчетностьКлиентСервер.СвойствоОпределено(СтруктураРеквизитовФормы, "мСохраненныйДок") Тогда
		ИмяФормы = Неопределено;
	ИначеЕсли РегламентированнаяОтчетностьКлиентСервер.СвойствоОпределено(СтруктураРеквизитовФормы, "мВыбраннаяФорма") 
			И ЗначениеЗаполнено(СтруктураРеквизитовФормы.мВыбраннаяФорма) Тогда
		ИмяФормы = СтруктураРеквизитовФормы.мВыбраннаяФорма;
	ИначеЕсли РегламентированнаяОтчетностьКлиентСервер.СвойствоОпределено(СтруктураРеквизитовФормы, "мСохраненныйДок") 
			И РегламентированнаяОтчетностьКлиентСервер.СвойствоОпределено(СтруктураРеквизитовФормы.мСохраненныйДок, "ВыбраннаяФорма") 
			И ЗначениеЗаполнено(СтруктураРеквизитовФормы.мСохраненныйДок.ВыбраннаяФорма) Тогда
		ИмяФормы = СтруктураРеквизитовФормы.мСохраненныйДок.ВыбраннаяФорма;
	КонецЕсли;
	
	Возврат ИмяФормы;
	
КонецФункции

Функция ИДОтчета(Объект)
	
	СоставляющиеИмениФормы = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Объект.ИмяФормы, ".");
	
	Если СоставляющиеИмениФормы.Количество() >= 1 Тогда
		ИДОтчета = ВРЕГ(СоставляющиеИмениФормы[1]);
	Иначе
		ИДОтчета = Неопределено;
	КонецЕсли;
	
	Возврат ИДОтчета;
	
КонецФункции


Функция ПолучитьКраткуюВерсиюОтчета(ОбъектОтчет) Экспорт

	Если РегламентированнаяОтчетностьКлиентСервер.СвойствоОпределено(ОбъектОтчет, "мВерсияОтчета") Тогда
		ПолнаяВерсияОтчета = ОбъектОтчет.мВерсияОтчета;
		КраткаяВерсия = ВыделитьКраткуюВерсиюОтчетаИзПолной(ПолнаяВерсияОтчета);
		Возврат ?(ЗначениеЗаполнено(КраткаяВерсия), КраткаяВерсия, Неопределено);
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

Функция ВыделитьКраткуюВерсиюОтчетаИзПолной(ПолнаяВерсияОтчета)
	
	Если НЕ ЗначениеЗаполнено(ПолнаяВерсияОтчета) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ВхождениеПробела = СтрНайти(ПолнаяВерсияОтчета, " ");
	Если ВхождениеПробела = 0 Тогда
		Возврат Неопределено;
	Иначе
		Возврат СокрЛП(Сред(ПолнаяВерсияОтчета, ВхождениеПробела + 1));
	КонецЕсли;
	
КонецФункции

// Предназначена для формирования заголовка формы уведомления о блокировках (УведомлениеОБлокировке)
Функция ПредставлениеОбъектаБлокировки(Объект)
	
	ПредставлениеОтчета = СокрЛП(Объект.Заголовок) + ".";
	Если ТипЗнч(Объект) = Тип("ФормаКлиентскогоПриложения") Тогда
		
		ПредставлениеФормы = Неопределено;
		СтруктураРеквизитовФормы = Объект.СтруктураРеквизитовФормы;
		
		
		Если РегламентированнаяОтчетностьКлиентСервер.СвойствоОпределено(СтруктураРеквизитовФормы, "мВыбраннаяФорма") Тогда
			
			ВыбраннаяФорма = СтруктураРеквизитовФормы.мВыбраннаяФорма;
			ИДОтчета = ИДОтчета(Объект);
			
			ПредставлениеФормы = ОнлайнСервисыРегламентированнойОтчетностиВызовСервера.ПредставлениеФормы(ИДОтчета, ВыбраннаяФорма);
			
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(ПредставлениеФормы) Тогда
			Если РегламентированнаяОтчетностьКлиентСервер.СвойствоОпределено(СтруктураРеквизитовФормы, "мДатаНачалаПериодаОтчета") 
					И РегламентированнаяОтчетностьКлиентСервер.СвойствоОпределено(СтруктураРеквизитовФормы, "мДатаКонцаПериодаОтчета") Тогда
				ДатаНачалаПериодаОтчета = СтруктураРеквизитовФормы.мДатаНачалаПериодаОтчета;
				ДатаКонцаПериодаОтчета = СтруктураРеквизитовФормы.мДатаКонцаПериодаОтчета;
				Если ЗначениеЗаполнено(ДатаНачалаПериодаОтчета) И ЗначениеЗаполнено(ДатаКонцаПериодаОтчета) Тогда
					ПредставлениеФормы = "за период " + ПредставлениеПериода(НачалоДня(ДатаНачалаПериодаОтчета), КонецДня(ДатаКонцаПериодаОтчета), "ФП = Истина");
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(ПредставлениеФормы) Тогда
			Возврат ПредставлениеОтчета;
		Иначе
			Возврат ПредставлениеОтчета + "<BR>" + СокрЛП(ПредставлениеФормы) + ".";
		КонецЕсли;
		
	Иначе
		Возврат ПредставлениеОтчета;
	КонецЕсли;
	
КонецФункции

Процедура ПопытатьсяПерейтиПоНавигационнойСсылке(Ссылка) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Ссылка) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Попытка
		
		ПерейтиПоНавигационнойСсылке(Ссылка);
		
	Исключение
		
		ПоказатьПредупреждение(, НСтр("ru = 'Не удалось перейти по указанной ссылке!';
										|en = 'Не удалось перейти по указанной ссылке!'"));
		
	КонецПопытки; 
	
КонецПроцедуры

// Возвращает дополнительный фильтр гиперссылки на монитор изменений законодательства (год, квартал)
//
// Параметры:
//   ДатаКонцаПериодаОтчета - Дата - дата конца периода для данной формы реглотчета.
//
// Возвращаемое значение:
//   Строка
//
Функция ПостфиксСсылки(ДатаКонцаПериодаОтчета) Экспорт
	МесяцКонцаКварталаОтчета = Месяц(КонецКвартала(ДатаКонцаПериодаОтчета));
	КварталОтчета = МесяцКонцаКварталаОтчета/3;
	
	Возврат СтрШаблон("&year=%1&q[%2]=true", Формат(Год(ДатаКонцаПериодаОтчета),"ЧГ=0"), Строка(КварталОтчета));
КонецФункции

#КонецОбласти