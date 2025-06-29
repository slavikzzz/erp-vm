#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Инициализирует параметры заполнения видов запасов дополнительных свойств документа, используемых при записи документа
// в режиме 'Проведения' или 'Отмены проведения'.
//
// Параметры:
//	ДокументОбъект - ДокументОбъект.ОтчетКомитентуОСписании - документ, для которого выполняется инициализация параметров.
//	РежимЗаписи - РежимЗаписиДокумента - режим записи документа.
//
Процедура ИнициализироватьПараметрыЗаполненияВидовЗапасовДляПроведения(ДокументОбъект, РежимЗаписи = Неопределено) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Заполняет реквизиты, хранящие информацию о видах запасов и аналитиках учета номенклатуры в табличной части 'Товары'
// документа, а также заполняет табличную часть 'ВидыЗапасов'.
//
// Параметры:
//	Отказ - Булево - признак того, что не удалось заполнить данные.
//	ТаблицыДокумента - см. Документы.ОтчетКомитентуОСписании.КоллекцияТабличныхЧастейТоваров.
//
Процедура ЗаполнитьВидыЗапасовПриОбмене(Отказ, ТаблицыДокумента) Экспорт
	
	ЗаполнитьАналитикиУчетаНоменклатурыВТабличныхЧастяхТоваров();
	
	Если ТаблицыДокумента <> Неопределено Тогда
		ЗаполнитьАналитикиУчетаНоменклатурыВТабличныхЧастяхТоваров(ТаблицыДокумента);
		ДополнительныеСвойства.Вставить("ТаблицыЗаполненияВидовЗапасовПриОбмене", ТаблицыДокумента);
	Иначе
		ИмяПараметра = "ТаблицыДокумента";
		
		ТекстИсключения = НСтр("ru = 'Для заполнения видов запасов не передан параметр ""%1"".';
								|en = 'The ""%1"" parameter is not transferred to fill in the inventory owner attributes.'");
		ТекстИсключения = СтрШаблон(ТекстИсключения, ИмяПараметра);
		
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	ЗаполнитьВидыЗапасов(Отказ);
	ДополнительныеСвойства.Удалить("ТаблицыЗаполненияВидовЗапасовПриОбмене");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Автор = Пользователи.ТекущийПользователь();
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура")
	   И ДанныеЗаполнения.Свойство("ЗаполнятьПоТоварамКОформлению") Тогда
		
		Партнер = ДанныеЗаполнения.Партнер;
		Контрагент = ДанныеЗаполнения.Контрагент;
		Соглашение = ДанныеЗаполнения.Соглашение;
		Договор = ДанныеЗаполнения.Договор;
		НалогообложениеНДС = ДанныеЗаполнения.НалогообложениеНДС;
		НаправленияДеятельностиСервер.ЗаполнитьНаправлениеПоУмолчанию(НаправлениеДеятельности, Соглашение, Договор);
		НачалоПериода = ДанныеЗаполнения.НачалоПериода;
		КонецПериода = ДанныеЗаполнения.КонецПериода;
		Если НачалоМесяца(КонецПериода) < НачалоМесяца(ТекущаяДатаСеанса()) Тогда
			Дата = КонецПериода;
		КонецЕсли;
		Если ЗначениеЗаполнено(Соглашение) Тогда
			ЗаполнитьУсловияЗакупокПоСоглашению();
			Организация = ДанныеЗаполнения.Организация;
			Договор = ДанныеЗаполнения.Договор;
			Контрагент = ДанныеЗаполнения.Контрагент;
		Иначе
			Валюта = ДанныеЗаполнения.Валюта;
			Организация = ДанныеЗаполнения.Организация;
			Если Не ЗначениеЗаполнено(Контрагент) Тогда
				ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
			КонецЕсли;
			Если Не ЗначениеЗаполнено(Договор) Тогда
				
				ДопПараметры = ЗакупкиСервер.ДополнительныеПараметрыОтбораДоговоров();
				ДопПараметры.ВалютаВзаиморасчетов = Валюта;
				Договор = ЗакупкиСервер.ПолучитьДоговорПоУмолчанию(
					ЭтотОбъект,
					Перечисления.ХозяйственныеОперации.ПриемНаКомиссию,
					ДопПараметры);
					
			КонецЕсли;
		КонецЕсли;
		
		ПартнерыИКонтрагенты.ЗаполнитьКонтактноеЛицоПартнераПоУмолчанию(Партнер, КонтактноеЛицо);
		
		ПараметрыЗаполнения = Документы.ОтчетКомитенту.ПараметрыЗаполненияНалогообложенияНДСЗакупки(ЭтотОбъект);
		УчетНДСУП.ЗаполнитьНалогообложениеНДСЗакупки(НалогообложениеНДС, ПараметрыЗаполнения);
		
		КомиссионнаяТорговляСервер.ЗаполнитьТоварыПоОстаткамКОформлениюОтчетовКомитентуОСписании(ЭтотОбъект);
		
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка." + Метаданные().Имя) Тогда
		
		ИсправлениеДокументов.ЗаполнитьИсправление(ЭтотОбъект, ДанныеЗаполнения);
		
	КонецЕсли;
	ОтветственныеЛицаСервер.ЗаполнитьМенеджера(ЭтотОбъект, Ложь);
	ЗаполнениеОбъектовПоСтатистике.ЗаполнитьРеквизитыОбъекта(ЭтотОбъект, ДанныеЗаполнения);
	
	Если Не ЗначениеЗаполнено(Менеджер) Тогда
		Менеджер = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
 	ВзаиморасчетыСервер.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения);
	
	ОтчетКомитентуОСписанииЛокализация.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если Не ЗначениеЗаполнено(Соглашение) Или Не ОбщегоНазначенияУТ.ЗначениеРеквизитаОбъектаТипаБулево(Соглашение, "ИспользуютсяДоговорыКонтрагентов") Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Договор");
	КонецЕсли;
	
	НоменклатураСервер.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ);
	
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ);
	
	КомиссионнаяТорговляСервер.ПроверитьКорректностьПериода(ЭтотОбъект, Отказ);
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ);
	
	ИсправлениеДокументов.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);
	
	Если ЗначениеЗаполнено(КонецПериода)
		И НачалоМесяца(Дата) <> НачалоМесяца(КонецПериода) Тогда
		
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Дата документа и дата окончания периода %1 должны быть в одном месяце';
							|en = 'Document date and period end date %1 shall be in one month'"),
						Формат(КонецПериода, "ДЛФ=DD"));
		
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, ЭтотОбъект, "Дата", , Отказ);
	КонецЕсли;
	
	ОтчетКомитентуОСписанииЛокализация.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ИсправлениеДокументов.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	НоменклатураСервер.ОкруглитьКоличествоШтучныхТоваров(ЭтотОбъект, РежимЗаписи);
	
	РасчетСуммаДокумента = Товары.Итог("СуммаСНДС");
	Если СуммаДокумента <> РасчетСуммаДокумента Тогда
		СуммаДокумента = РасчетСуммаДокумента;
	КонецЕсли;
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		ЗаполнитьАналитикиУчетаНоменклатурыВТабличныхЧастяхТоваров();
		ЗаполнитьВидыЗапасов(Отказ);
		
	ИначеЕсли РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		Если Не ВидыЗапасовУказаныВручную Тогда
			ВидыЗапасов.Очистить();
		КонецЕсли;
	КонецЕсли;
	
	ОбщегоНазначенияУТ.ЗаполнитьИдентификаторыДокумента(ЭтотОбъект, "ВидыЗапасов");
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		НоменклатураПартнеровСервер.ЗаполнитьПустоеСопоставлениеВНоменклатуреПартнераПоНоменклатуреИБ(Товары, Отказ);
	КонецЕсли;
	
	Если ЭтоНовый() И НЕ ЗначениеЗаполнено(Номер) Тогда
		УстановитьНовыйНомер();
	КонецЕсли;
	
	ВзаиморасчетыСервер.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи);
	
	ОтчетКомитентуОСписанииЛокализация.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
	Если Не ЗначениеЗаполнено(Автор) И ЭтоНовый() Тогда
		Автор = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
	ОтчетКомитентуОСписанииЛокализация.ПриЗаписи(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
	ОтчетКомитентуОСписанииЛокализация.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
	ОтчетКомитентуОСписанииЛокализация.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ИсправлениеДокументов.ПриКопировании(ЭтотОбъект, ОбъектКопирования);
	
	ВидыЗапасовУказаныВручную = Ложь;
	
	ПараметрыЗаполнения = Документы.ОтчетКомитенту.ПараметрыЗаполненияНалогообложенияНДСЗакупки(ЭтотОбъект);
	УчетНДСУП.ЗаполнитьНалогообложениеНДСЗакупки(НалогообложениеНДС, ПараметрыЗаполнения);
	
	СтруктураДействий = Новый Структура;
	КэшированныеЗначения = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруКэшируемыеЗначения();
	СтруктураДействий.Вставить("СкорректироватьСтавкуНДС", ОбработкаТабличнойЧастиКлиентСервер.ПараметрыЗаполненияСтавкиНДС(ЭтотОбъект));
	ОбработкаТабличнойЧастиСервер.ОбработатьТЧ(Товары, СтруктураДействий, КэшированныеЗначения);
	
	СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПараметрыПересчетаСуммыНДСВТЧ(ЭтотОбъект);
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
	ОбработкаТабличнойЧастиСервер.ОбработатьТЧ(КэшированныеЗначения.ОбработанныеСтроки, СтруктураДействий, Неопределено);
	
	ВзаиморасчетыСервер.ПриКопировании(ЭтотОбъект);
	
	ВидыЗапасов.Очистить();

	ОтчетКомитентуОСписанииЛокализация.ПриКопировании(ЭтотОбъект, ОбъектКопирования);
	Автор = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ЗаполнитьУсловияЗакупок(Знач УсловияЗакупок) Экспорт
	
	Если УсловияЗакупок <> Неопределено Тогда
	
		ДокументЗакупки = ЭтотОбъект;
		ДокументЗакупки.Валюта = УсловияЗакупок.Валюта;
		НаправлениеДеятельности = УсловияЗакупок.НаправлениеДеятельности;
		
		Если ЗначениеЗаполнено(УсловияЗакупок.Организация) Тогда
			ДокументЗакупки.Организация = УсловияЗакупок.Организация;
		КонецЕсли;
			
		Если ЗначениеЗаполнено(УсловияЗакупок.Контрагент) Тогда
			ДокументЗакупки.Контрагент = УсловияЗакупок.Контрагент;
		КонецЕсли;
		
		ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
		
		Если УсловияЗакупок.ИспользуютсяДоговорыКонтрагентов <> Неопределено И УсловияЗакупок.ИспользуютсяДоговорыКонтрагентов Тогда
			
			ДопПараметры = ЗакупкиСервер.ДополнительныеПараметрыОтбораДоговоров();
			ДопПараметры.ВалютаВзаиморасчетов = Валюта;
			Договор = ЗакупкиСервер.ПолучитьДоговорПоУмолчанию(
				ЭтотОбъект,
				Перечисления.ХозяйственныеОперации.ПриемНаКомиссию,
				ДопПараметры);
				
			Если ПолучитьФункциональнуюОпцию("ИспользоватьУчетЗатратПоНаправлениямДеятельности") 
				ИЛИ ПолучитьФункциональнуюОпцию("ИспользоватьУчетРасчетовСПоставщикамиПоНаправлениямДеятельности") Тогда
				НаправленияДеятельностиСервер.ЗаполнитьНаправлениеПоУмолчанию(НаправлениеДеятельности, Соглашение, Договор);
			КонецЕсли;
		
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(УсловияЗакупок.ИспользуютсяДоговорыКонтрагентов) 
			ИЛИ НЕ УсловияЗакупок.ИспользуютсяДоговорыКонтрагентов Тогда
			ОплатаВВалюте = УсловияЗакупок.ОплатаВВалюте;
		Иначе
			ОплатаВВалюте = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Договор, "ОплатаВВалюте");
		КонецЕсли;
		
		ДокументЗакупки.ЦенаВключаетНДС = УсловияЗакупок.ЦенаВключаетНДС;
		
		Если ЗначениеЗаполнено(УсловияЗакупок.ГруппаФинансовогоУчета) Тогда
			ГруппаФинансовогоУчета = УсловияЗакупок.ГруппаФинансовогоУчета;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьУсловияЗакупокПоСоглашению(ПересчитатьЦены = Истина) Экспорт
	
	УсловияЗакупок = ЗакупкиСервер.ПолучитьУсловияЗакупок(Соглашение);
	ЗаполнитьУсловияЗакупок(УсловияЗакупок);
	
	ПараметрыЗаполнения = Документы.ОтчетКомитенту.ПараметрыЗаполненияНалогообложенияНДСЗакупки(ЭтотОбъект);
	УчетНДСУП.ЗаполнитьНалогообложениеНДСЗакупки(НалогообложениеНДС, ПараметрыЗаполнения);
	
	Если ПересчитатьЦены Тогда
		СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПараметрыПересчетаСуммыНДСВСтрокеТЧ(ЭтотОбъект);
		ПараметрыЗаполнения = ЦеныПартнеровЗаполнениеСервер.НовыйПараметрыЗаполненияЗаполнитьЦены();
		ПараметрыЗаполнения.Вставить("ПоляЗаполнения", "Цена, СтавкаНДС");
		ПараметрыЗаполнения.Вставить("Дата", Дата);
		ПараметрыЗаполнения.Вставить("Валюта", Валюта);
		ПараметрыЗаполнения.Вставить("Соглашение", Соглашение);
		ПараметрыЗаполнения.Вставить("НалогообложениеНДС", НалогообложениеНДС);
		СтруктураДействий = Новый Структура;
		СтруктураДействий.Вставить("ПересчитатьСумму", "КоличествоУпаковок");
		СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
		СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
		
		ЦеныПартнеровЗаполнениеСервер.ЗаполнитьЦены(
			Товары,
			Неопределено, // Массив строк
			ПараметрыЗаполнения,
			СтруктураДействий);
			
	КонецЕсли;
	
	КомиссионнаяТорговляСервер.ЗаполнитьСуммуСНДС(Товары, ЦенаВключаетНДС);
	
КонецПроцедуры

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)

	Организация     = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	
	ПараметрыЗаполнения = Документы.ОтчетКомитенту.ПараметрыЗаполненияНалогообложенияНДСЗакупки(ЭтотОбъект);
	УчетНДСУП.ЗаполнитьНалогообложениеНДСЗакупки(НалогообложениеНДС, ПараметрыЗаполнения);
	
КонецПроцедуры

#КонецОбласти

#Область ВидыЗапасов

Процедура ЗаполнитьВидыЗапасов(Отказ)
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерВременныхТаблиц		= ВременныеТаблицыДанныхДокумента();
	ПерезаполнитьВидыЗапасов	= ЗапасыСервер.ПроверитьНеобходимостьПерезаполненияВидовЗапасовДокумента(ЭтотОбъект);
	
	Если Не Проведен
		Или ПерезаполнитьВидыЗапасов
		Или ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц)
		Или ЗапасыСервер.ПроверитьИзменениеТоваровПоКоличествуИСумме(МенеджерВременныхТаблиц) Тогда
	 
		ПараметрыЗаполнения = ЗапасыСервер.ПараметрыЗаполненияВидовЗапасов();
		ПараметрыЗаполнения.ПриНехваткеТоваровОрганизацииЗаполнятьВидамиЗапасовПоУмолчанию = Ложь;
		ПараметрыЗаполнения.БезОтбораПоНомерамГТД = Истина;
		ПараметрыЗаполнения.СторнируемыйДокумент = СторнируемыйДокумент;
		
		ОтборыВидовЗапасов = ПараметрыЗаполнения.ОтборыВидовЗапасов;
		ОтборыВидовЗапасов.Организация = Организация;
		ОтборыВидовЗапасов.ВладелецТовара = Партнер;
		ОтборыВидовЗапасов.Договор = Договор;
		ОтборыВидовЗапасов.Валюта = Валюта;
		ОтборыВидовЗапасов.ТипЗапасов = Перечисления.ТипыЗапасов.КомиссионныйТовар;
		
		ПараметрыЗаполнения.ИмяТаблицыОстатков = "ТоварыКОформлениюОтчетовКомитентуОСписании";
		
		ЗапасыСервер.ЗаполнитьВидыЗапасовПоОстаткамКОформлению(ЭтотОбъект,
																МенеджерВременныхТаблиц,
																Отказ,
																ПараметрыЗаполнения);
		
		ВидыЗапасов.Свернуть("АналитикаУчетаНоменклатуры, ВидЗапасов, НомерГТД, СтавкаНДС",
							"Количество, КоличествоПоРНПТ, СуммаСНДС, СуммаНДС");
		
	КонецЕсли;
	
КонецПроцедуры

Функция ВременныеТаблицыДанныхДокумента()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	&Дата			КАК Дата,
	|	&Организация	КАК Организация,
	|	&Партнер		КАК Партнер,
	|	&Контрагент		КАК Контрагент,
	|	&Соглашение		КАК Соглашение,
	|	&Договор		КАК Договор,
	|	&Валюта			КАК Валюта,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка) КАК НалогообложениеНДС,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОтчетКомитентуОСписании) КАК ХозяйственнаяОперация,
	|	ЛОЖЬ			КАК ЕстьСделкиВТабличнойЧасти,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.КомиссионныйТовар) КАК ТипЗапасов
	|ПОМЕСТИТЬ ТаблицаДанныхДокумента
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки							КАК НомерСтроки,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры			КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.Номенклатура							КАК Номенклатура,
	|	ТаблицаТоваров.Характеристика						КАК Характеристика,
	|	ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)	КАК Серия,
	|	0													КАК СтатусУказанияСерий,
	|	ТаблицаТоваров.Количество							КАК Количество,
	|	ВЫБОР
	|		КОГДА НЕ &ИспользоватьУчетПрослеживаемыхИмпортныхТоваров
	|				ИЛИ НАЧАЛОПЕРИОДА(&Дата, МЕСЯЦ) < &ДатаНачалаУчетаПрослеживаемыхИмпортныхТоваров
	|			ТОГДА 0
	|		ИНАЧЕ &ТекстПоляТаблицаТоваровКоличествоПоРНПТ_
	|	КОНЕЦ												КАК КоличествоПоРНПТ,
	|	ТаблицаТоваров.СтавкаНДС							КАК СтавкаНДС,
	|	ТаблицаТоваров.СуммаСНДС							КАК СуммаСНДС,
	|	ТаблицаТоваров.СуммаНДС								КАК СуммаНДС,
	|	0													КАК СуммаВознаграждения,
	|	0													КАК СуммаНДСВознаграждения,
	|	ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)			КАК Склад,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка)	КАК Сделка,
	|	ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)		КАК Назначение,
	|	ИСТИНА												КАК ПодбиратьВидыЗапасов,
	|	&ТекстПоляТаблицаТоваровНомерГТД_					КАК НомерГТД
	|ПОМЕСТИТЬ ТаблицаТоваров
	|ИЗ
	|	&ТаблицаТоваров КАК ТаблицаТоваров
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаВидыЗапасов.НомерСтроки						КАК НомерСтроки,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры		КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаВидыЗапасов.ВидЗапасов						КАК ВидЗапасов,
	|	ТаблицаВидыЗапасов.НомерГТД							КАК НомерГТД,
	|	ТаблицаВидыЗапасов.СтавкаНДС						КАК СтавкаНДС,
	|	ТаблицаВидыЗапасов.Количество						КАК Количество,
	|	ВЫБОР
	|		КОГДА НЕ &ИспользоватьУчетПрослеживаемыхИмпортныхТоваров
	|				ИЛИ НАЧАЛОПЕРИОДА(&Дата, МЕСЯЦ) < &ДатаНачалаУчетаПрослеживаемыхИмпортныхТоваров
	|			ТОГДА 0
	|		ИНАЧЕ ТаблицаВидыЗапасов.КоличествоПоРНПТ
	|	КОНЕЦ												КАК КоличествоПоРНПТ,
	|	ТаблицаВидыЗапасов.СуммаСНДС						КАК СуммаСНДС,
	|	ТаблицаВидыЗапасов.СуммаНДС							КАК СуммаНДС,
	|	0													КАК СуммаВознаграждения,
	|	0													КАК СуммаНДСВознаграждения,
	|	ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)			КАК СкладОтгрузки,
	|	ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)			КАК Склад,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка)	КАК Сделка,
	|	&ВидыЗапасовУказаныВручную							КАК ВидыЗапасовУказаныВручную
	|ПОМЕСТИТЬ ВтВидыЗапасов
	|ИЗ
	|	&ТаблицаВидыЗапасов КАК ТаблицаВидыЗапасов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаВидыЗапасов.НомерСтроки					КАК НомерСтроки,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры	КАК АналитикаУчетаНоменклатуры,
	|	Аналитика.Номенклатура							КАК Номенклатура,
	|	Аналитика.Характеристика						КАК Характеристика,
	|	Аналитика.Серия									КАК Серия,
	|	ТаблицаВидыЗапасов.ВидЗапасов					КАК ВидЗапасов,
	|	НЕОПРЕДЕЛЕНО									КАК ВидЗапасовПолучателя,
	|	ТаблицаВидыЗапасов.НомерГТД						КАК НомерГТД,
	|	ТаблицаВидыЗапасов.СтавкаНДС					КАК СтавкаНДС,
	|	ТаблицаВидыЗапасов.Количество					КАК Количество,
	|	ТаблицаВидыЗапасов.КоличествоПоРНПТ				КАК КоличествоПоРНПТ,
	|	ТаблицаВидыЗапасов.СуммаСНДС					КАК СуммаСНДС,
	|	ТаблицаВидыЗапасов.СуммаНДС						КАК СуммаНДС,
	|	0												КАК СуммаВознаграждения,
	|	0												КАК СуммаНДСВознаграждения,
	|	ТаблицаВидыЗапасов.СкладОтгрузки				КАК СкладОтгрузки,
	|	ТаблицаВидыЗапасов.Склад						КАК Склад,
	|	ТаблицаВидыЗапасов.Сделка						КАК Сделка,
	|	&ВидыЗапасовУказаныВручную КАК ВидыЗапасовУказаныВручную
	|	
	|ПОМЕСТИТЬ ТаблицаВидыЗапасов
	|ИЗ
	|	ВтВидыЗапасов КАК ТаблицаВидыЗапасов
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлючиАналитикиУчетаНоменклатуры КАК Аналитика
	|		ПО ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры = Аналитика.Ссылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	АналитикаУчетаНоменклатуры";
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	ТаблицаТоваров = ?(ДополнительныеСвойства.Свойство("ТаблицыЗаполненияВидовЗапасовПриОбмене")
							И ДополнительныеСвойства.ТаблицыЗаполненияВидовЗапасовПриОбмене <> Неопределено
							И ДополнительныеСвойства.ТаблицыЗаполненияВидовЗапасовПриОбмене.Свойство("Товары"),
						ДополнительныеСвойства.ТаблицыЗаполненияВидовЗапасовПриОбмене.Товары,
						Товары);
	
	Запрос.УстановитьПараметр("Ссылка",						Ссылка);
	Запрос.УстановитьПараметр("Дата",						Дата);
	Запрос.УстановитьПараметр("Организация",				Организация);
	Запрос.УстановитьПараметр("Партнер",					Партнер);
	Запрос.УстановитьПараметр("Контрагент",					Контрагент);
	Запрос.УстановитьПараметр("Соглашение",					Соглашение);
	Запрос.УстановитьПараметр("Договор",					Договор);
	Запрос.УстановитьПараметр("Валюта",						Валюта);
	Запрос.УстановитьПараметр("ВидыЗапасовУказаныВручную",	ВидыЗапасовУказаныВручную);
	Запрос.УстановитьПараметр("ТаблицаТоваров",				ТаблицаТоваров);
	Запрос.УстановитьПараметр("ТаблицаВидыЗапасов",			ВидыЗапасов);
	
	УчетПрослеживаемыхТоваровЛокализация.УстановитьПараметрыИспользованияУчетаПрослеживаемыхТоваров(Запрос);
	
	ЗапасыСервер.ДополнитьВременныеТаблицыОбязательнымиКолонками(Запрос);
	
	ОбщегоНазначенияУТ.ЗаменитьОтсутствующиеПоляТаблицыЗначенийВТекстеЗапроса(
		ТаблицаТоваров,
		Запрос.Текст,
		"&ТекстПоляТаблицаТоваровКоличествоПоРНПТ_",
		"ТаблицаТоваров",
		"КоличествоПоРНПТ",
		"ТаблицаТоваров.КоличествоПоРНПТ",
		"0");
	
	ОбщегоНазначенияУТ.ЗаменитьОтсутствующиеПоляТаблицыЗначенийВТекстеЗапроса(
		ТаблицаТоваров,
		Запрос.Текст,
		"&ТекстПоляТаблицаТоваровНомерГТД_",
		"ТаблицаТоваров",
		"НомерГТД",
		"ТаблицаТоваров.НомерГТД",
		"ЗНАЧЕНИЕ(Справочник.НомераГТД.ПустаяСсылка)");
	
	Запрос.Выполнить();
	
	Возврат МенеджерВременныхТаблиц;
	
КонецФункции

Функция ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц)
	
	ИменаРеквизитов = "Организация, Дата, Партнер, Соглашение, Валюта";
	
	Возврат ЗапасыСервер.ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц, Ссылка, ИменаРеквизитов);
	
КонецФункции

// Заполняет аналитики учета номенклатуры в табличных частях документа, хранящих информацию о товарах.
// Если параметр не передан, тогда будет выполнено заполнение данных в табличных частях документа.
//
// Параметры:
//	ТаблицыДокумента - см. Документы.ОтчетКомитентуОСписании.КоллекцияТабличныхЧастейТоваров.
//
Процедура ЗаполнитьАналитикиУчетаНоменклатурыВТабличныхЧастяхТоваров(ТаблицыДокумента = Неопределено)
	
	Если ТаблицыДокумента = Неопределено Тогда
		ТаблицыДокумента = Документы.ОтчетКомитентуОСписании.КоллекцияТабличныхЧастейТоваров();
		
		ЗаполнитьЗначенияСвойств(ТаблицыДокумента, ЭтотОбъект);
	КонецЕсли;
	
	ТаблицаТовары = ТаблицыДокумента.Товары;
	
	МестаУчета = РегистрыСведений.АналитикаУчетаНоменклатуры.МестаУчета(
					Перечисления.ХозяйственныеОперации.ОтчетКомитенту,
					Неопределено,
					Подразделение,
					Партнер);
	ИменаПолей = РегистрыСведений.АналитикаУчетаНоменклатуры.ИменаПолейКоллекцииПоУмолчанию();
	ИменаПолей.СтатусУказанияСерий = "";
	ИменаПолей.Назначение = "";
	
	РегистрыСведений.АналитикаУчетаНоменклатуры.ЗаполнитьВКоллекции(ТаблицаТовары, МестаУчета, ИменаПолей);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
