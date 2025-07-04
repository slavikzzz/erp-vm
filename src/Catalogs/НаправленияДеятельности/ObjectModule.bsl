
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Если Статус.Пустая() Тогда
		Статус = Перечисления.СтатусыНаправленияДеятельности.Используется;
	КонецЕсли;
	
	ШаблонНазначения = Справочники.НаправленияДеятельности.ШаблонНазначения(ЭтотОбъект);
	Справочники.Назначения.ПроверитьЗаполнитьПередЗаписью(
		Назначение,
		ШаблонНазначения,
		ЭтотОбъект,
		"УчетЗатрат",
		Отказ,
		Истина,
		Не УчетЗатрат);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	Если Не ЭтоНовый() Тогда
		РеквизитДоЗаписи = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка,
			"ДопускаетсяОбособлениеСверхПотребности");
		ДополнительныеСвойства.Вставить("ОбновитьНазначение",
			РеквизитДоЗаписи <> ДопускаетсяОбособлениеСверхПотребности);
	Иначе
		ДополнительныеСвойства.Вставить("ОбновитьНазначение", Не ДопускаетсяОбособлениеСверхПотребности);
	КонецЕсли;
	
	ОбщегоНазначенияУТ.ПодготовитьДанныеДляСинхронизацииКлючей(ЭтотОбъект, ПараметрыСинхронизацииКлючей());	
	
	НаправленияДеятельностиЛокализация.ПередЗаписью(ЭтотОбъект, Отказ);
	Если УчетЗатрат Тогда
		ОбновлениеПризнакаДопускаетсяОбособлениеСверхПотребностиНеТребуется = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	ШаблонНазначения = Справочники.НаправленияДеятельности.ШаблонНазначения(ЭтотОбъект);
	ВидДеятельностиПоНалогообложениюНДС = УчетНДСУП.ВидДеятельностиПоНалогообложениюНДС(НалогообложениеНДС);
	Справочники.Назначения.ПриЗаписиСправочника(
		Назначение,
		ШаблонНазначения,
		ЭтотОбъект,
		ВидДеятельностиПоНалогообложениюНДС,
		ДополнительныеСвойства.ОбновитьНазначение);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	// Запись подчиненной константы.
	ОбеспечениеСервер.ИспользоватьУправлениеПеремещениемОбособленныхТоваровВычислитьИЗаписать();
	ОбеспечениеСервер.ИспользоватьНазначенияБезЗаказаВычислитьИЗаписать();
	
	ОбщегоНазначенияУТ.СинхронизироватьКлючи(ЭтотОбъект);
	
	НаправленияДеятельностиЛокализация.ПриЗаписи(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если НалогообложениеНДСОпределяетсяВДокументе Тогда
		МассивНепроверяемыхРеквизитов.Добавить("НалогообложениеНДС");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДатаОкончанияДеятельности)
		И ЗначениеЗаполнено(ДатаНачалаДеятельности) 
		И ДатаОкончанияДеятельности < ДатаНачалаДеятельности Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Дата окончания периода деятельности по направлению должна быть больше даты начала.';
				|en = 'The end date of the activity period by the line of business must be greater than the start date.'"), 
			, 
			"Объект." + Метаданные().Реквизиты.ДатаОкончанияДеятельности.Имя,
			,
			Отказ);
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	НаправленияДеятельностиЛокализация.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Если НЕ ЭтоГруппа Тогда
		Назначение = Справочники.Назначения.ПустаяСсылка();
		Если НалогообложениеНДСОпределяетсяВДокументе Тогда
			НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.ПустаяСсылка();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#Область СлужебныеПроцедурыИФункции

Функция ПараметрыСинхронизацииКлючей()
	
	Результат = Новый Соответствие;
	
	Результат.Вставить("Справочник.КлючиАналитикиУчетаПоПартнерам", "ПометкаУдаления");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
#КонецОбласти

#КонецЕсли