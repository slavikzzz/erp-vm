#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		ИспользоватьСоглашенияСКлиентами = ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСКлиентами");
		ИспользоватьКартыЛояльности = ПолучитьФункциональнуюОпцию("ИспользоватьКартыЛояльности");
		
		Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковПодарочныхСертификатов Тогда
			СоздатьПодарочныеСертификаты(Отказ);
		КонецЕсли;
		
		Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковОптовыхПродажЗаПрошлыеПериоды Тогда
			МестаУчета = РегистрыСведений.АналитикаУчетаНоменклатуры.МестаУчета(ХозяйственнаяОперация, Склад, Подразделение, Партнер);
			
			ИменаПолей = РегистрыСведений.АналитикаУчетаНоменклатуры.ИменаПолейКоллекцииПоУмолчанию();
			ИменаПолей.Назначение = "";
			ИменаПолей.СтатусУказанияСерий = "";
			ИменаПолей.Серия = "";
			
			РегистрыСведений.АналитикаУчетаНоменклатуры.ЗаполнитьВКоллекции(ОптовыеПродажи, МестаУчета, ИменаПолей);
			ЗаполнитьВидыЗапасов();
		КонецЕсли;
		
		Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковРозничныхПродажЗаПрошлыеПериоды Тогда
			
			Если ИспользоватьКартыЛояльности Тогда
				СоздатьКартыЛояльностиИЗаполнитьАналитикуУчетаПоПартнерам();
			Иначе
				ЗаполнитьАналитикуУчетаПоПартнерам();
			КонецЕсли;
			
			МестаУчета = РегистрыСведений.АналитикаУчетаНоменклатуры.МестаУчета(ХозяйственнаяОперация, Склад, Подразделение, Партнер);
			
			ИменаПолей = РегистрыСведений.АналитикаУчетаНоменклатуры.ИменаПолейКоллекцииПоУмолчанию();
			ИменаПолей.Назначение = "";
			ИменаПолей.СтатусУказанияСерий = "";
			ИменаПолей.Серия = "";
			
			РегистрыСведений.АналитикаУчетаНоменклатуры.ЗаполнитьВКоллекции(РозничныеПродажи, МестаУчета, ИменаПолей);
			ЗаполнитьВидыЗапасов();
		КонецЕсли;
		
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ОбщегоНазначенияУТ.ЗаполнитьИдентификаторыДокумента(	ЭтотОбъект, "ОптовыеПродажи,РозничныеПродажи,ПодарочныеСертификаты");

	ВводОстатковЛокализация.ВводОстатковОПродажахЗаПрошлыеПериодыПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ДополнительныеСвойства.Вставить("ПараметрыЗаполненияВидовЗапасов", ЗапасыСервер.ПараметрыЗаполненияВидовЗапасов());
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	ВводОстатковЛокализация.ВводОстатковОПродажахЗаПрошлыеПериодыОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ДополнительныеСвойства.Вставить("ПараметрыЗаполненияВидовЗапасов", ЗапасыСервер.ПараметрыЗаполненияВидовЗапасов());
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	ВводОстатковЛокализация.ВводОстатковОПродажахЗаПрошлыеПериодыОбработкаУдаленияПроведения(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	Если Не ОтражатьВОперативномУчете
		И Не ОтражатьВБУиНУ
		И Не ОтражатьВУУ Тогда
		
		ТекстСообщения = НСтр("ru = 'Операция должна отражаться в одном из учетов';
								|en = 'The operation must be recorded in one of accounting types'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , 
			"Объект.ОтражатьВОперативномУчете", , Отказ);
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	МассивНепроверяемыхРеквизитов.Добавить("Менеджер");
	МассивНепроверяемыхРеквизитов.Добавить("Контрагент");
	МассивНепроверяемыхРеквизитов.Добавить("Подразделение");
	МассивНепроверяемыхРеквизитов.Добавить("НалогообложениеНДС");
	
	Если ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.ВводОстатковОптовыхПродажЗаПрошлыеПериоды
		И ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.ВводОстатковРозничныхПродажЗаПрошлыеПериоды Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Склад");
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов.Добавить("ОптовыеПродажи.Упаковка");
	МассивНепроверяемыхРеквизитов.Добавить("РозничныеПродажи.Упаковка");
	
	Если ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.ВводОстатковОптовыхПродажЗаПрошлыеПериоды Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Партнер");
	КонецЕсли;
	
	Если Не ОтражатьВОперативномУчете
	 ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковФинансовогоРезультатаЗаПрошлыеПериоды Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Валюта");
	КонецЕсли;
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковПодарочныхСертификатов
		И ОтражатьВОперативномУчете Тогда
		
		ПодарочныеСертификатыСервер.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ);
		ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ВидПодарочногоСертификата, "ТипКарты");
		Если ЗначенияРеквизитов.ТипКарты = Перечисления.ТипыКарт.Магнитная Тогда
			МассивНепроверяемыхРеквизитов.Добавить("ПодарочныеСертификаты.Штрихкод");
		ИначеЕсли ЗначенияРеквизитов.ТипКарты = Перечисления.ТипыКарт.Штриховая Тогда
			МассивНепроверяемыхРеквизитов.Добавить("ПодарочныеСертификаты.МагнитныйКод");
		КонецЕсли;
		МассивНепроверяемыхРеквизитов.Добавить("Валюта");
	Иначе
		МассивНепроверяемыхРеквизитов.Добавить("ВидПодарочногоСертификата");
		МассивНепроверяемыхРеквизитов.Добавить("ПодарочныеСертификаты");
		МассивНепроверяемыхРеквизитов.Добавить("ПодарочныеСертификаты.Штрихкод");
		МассивНепроверяемыхРеквизитов.Добавить("ПодарочныеСертификаты.МагнитныйКод");
	КонецЕсли;
	
	Если ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.ВводОстатковФинансовогоРезультатаЗаПрошлыеПериоды Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ФинансовыйРезультатРасходы");
		МассивНепроверяемыхРеквизитов.Добавить("ФинансовыйРезультатРасходы.СтатьяРасходов");
		МассивНепроверяемыхРеквизитов.Добавить("ФинансовыйРезультатРасходы.АналитикаРасходов");
		МассивНепроверяемыхРеквизитов.Добавить("ФинансовыйРезультатРасходы.ДатаОтражения");
		МассивНепроверяемыхРеквизитов.Добавить("ФинансовыйРезультатДоходы");
		МассивНепроверяемыхРеквизитов.Добавить("ФинансовыйРезультатДоходы.СтатьяДоходов");
		МассивНепроверяемыхРеквизитов.Добавить("ФинансовыйРезультатДоходы.АналитикаДоходов");
		МассивНепроверяемыхРеквизитов.Добавить("ФинансовыйРезультатДоходы.ДатаОтражения");
	Иначе
		Если ФинансовыйРезультатРасходы.Количество() > 0 И ФинансовыйРезультатДоходы.Количество() = 0 Тогда
			МассивНепроверяемыхРеквизитов.Добавить("ФинансовыйРезультатДоходы");
			МассивНепроверяемыхРеквизитов.Добавить("ФинансовыйРезультатДоходы.СтатьяДоходов");
			МассивНепроверяемыхРеквизитов.Добавить("ФинансовыйРезультатДоходы.АналитикаДоходов");
			МассивНепроверяемыхРеквизитов.Добавить("ФинансовыйРезультатДоходы.ДатаОтражения");
		ИначеЕсли ФинансовыйРезультатРасходы.Количество() = 0 И ФинансовыйРезультатДоходы.Количество() > 0 Тогда
			МассивНепроверяемыхРеквизитов.Добавить("ФинансовыйРезультатРасходы");
			МассивНепроверяемыхРеквизитов.Добавить("ФинансовыйРезультатРасходы.СтатьяРасходов");
			МассивНепроверяемыхРеквизитов.Добавить("ФинансовыйРезультатРасходы.АналитикаРасходов");
			МассивНепроверяемыхРеквизитов.Добавить("ФинансовыйРезультатРасходы.ДатаОтражения");
		КонецЕсли;
	КонецЕсли;
	
	Если ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.ВводОстатковОптовыхПродажЗаПрошлыеПериоды Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ОптовыеПродажи");
		МассивНепроверяемыхРеквизитов.Добавить("ОптовыеПродажи.Номенклатура");
		МассивНепроверяемыхРеквизитов.Добавить("ОптовыеПродажи.Характеристика");
		МассивНепроверяемыхРеквизитов.Добавить("ОптовыеПродажи.Количество");
		МассивНепроверяемыхРеквизитов.Добавить("ОптовыеПродажи.Сумма");
		МассивНепроверяемыхРеквизитов.Добавить("ОптовыеПродажи.ДатаОтражения");
		МассивНепроверяемыхРеквизитов.Добавить("ОптовыеПродажи.Упаковка");
		МассивНепроверяемыхРеквизитов.Добавить("ОптовыеПродажи.КоличествоУпаковок");
		МассивНепроверяемыхРеквизитов.Добавить("ОптовыеПродажи.Цена");
	КонецЕсли;
	
	Если ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.ВводОстатковРозничныхПродажЗаПрошлыеПериоды Тогда
		МассивНепроверяемыхРеквизитов.Добавить("РозничныеПродажи");
		МассивНепроверяемыхРеквизитов.Добавить("РозничныеПродажи.ВидКартыЛояльности");
		МассивНепроверяемыхРеквизитов.Добавить("РозничныеПродажи.КартаЛояльности");
		МассивНепроверяемыхРеквизитов.Добавить("РозничныеПродажи.Номенклатура");
		МассивНепроверяемыхРеквизитов.Добавить("РозничныеПродажи.Характеристика");
		МассивНепроверяемыхРеквизитов.Добавить("РозничныеПродажи.Количество");
		МассивНепроверяемыхРеквизитов.Добавить("РозничныеПродажи.Сумма");
		МассивНепроверяемыхРеквизитов.Добавить("РозничныеПродажи.ДатаОтражения");
		МассивНепроверяемыхРеквизитов.Добавить("РозничныеПродажи.Упаковка");
		МассивНепроверяемыхРеквизитов.Добавить("РозничныеПродажи.КоличествоУпаковок");
		МассивНепроверяемыхРеквизитов.Добавить("РозничныеПродажи.Цена");
	КонецЕсли;
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковОптовыхПродажЗаПрошлыеПериоды Тогда
		ПараметрыПроверки = НоменклатураСервер.ПараметрыПроверкиЗаполненияХарактеристик();
		ПараметрыПроверки.ИмяТЧ = "ОптовыеПродажи";
		НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ, ПараметрыПроверки);
		Для ИндексСтроки = 0 По ОптовыеПродажи.Количество()-1 Цикл
			Если ОптовыеПродажи.Получить(ИндексСтроки).ДатаОтражения > Дата Тогда
				ТекстОшибки = НСтр("ru = 'Значение колонки ""Период"" в строке %НомерСтроки% не должно быть больше даты документа';
									|en = 'The ""Period"" column value in line %НомерСтроки% cannot be greater than the document date'");
				ТекстОшибки =  СтрЗаменить(ТекстОшибки, "%НомерСтроки%", ОптовыеПродажи.Получить(ИндексСтроки).НомерСтроки);
				ОбщегоНазначения.СообщитьПользователю(
					ТекстОшибки,
					ЭтотОбъект,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ОптовыеПродажи", ОптовыеПродажи.Получить(ИндексСтроки).НомерСтроки, "ДатаОтражения"),
					,
					Отказ);
			КонецЕсли;
		КонецЦикла;
	ИначеЕсли ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковРозничныхПродажЗаПрошлыеПериоды Тогда
		ПараметрыПроверки = НоменклатураСервер.ПараметрыПроверкиЗаполненияХарактеристик();
		ПараметрыПроверки.ИмяТЧ = "РозничныеПродажи";
		НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ, ПараметрыПроверки);
		Для ИндексСтроки = 0 По РозничныеПродажи.Количество()-1 Цикл
			Если РозничныеПродажи.Получить(ИндексСтроки).ДатаОтражения > Дата Тогда
				ТекстОшибки = НСтр("ru = 'Значение колонки ""Период"" в строке %НомерСтроки% не должно быть больше даты документа';
									|en = 'The ""Period"" column value in line %НомерСтроки% cannot be greater than the document date'");
				ТекстОшибки =  СтрЗаменить(ТекстОшибки, "%НомерСтроки%", РозничныеПродажи.Получить(ИндексСтроки).НомерСтроки);
				ОбщегоНазначения.СообщитьПользователю(
					ТекстОшибки,
					ЭтотОбъект,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("РозничныеПродажи", РозничныеПродажи.Получить(ИндексСтроки).НомерСтроки, "ДатаОтражения"),
					,
					Отказ);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	ДополнитьПроверяемыеРеквизиты(ПроверяемыеРеквизиты);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	ВводОстатковЛокализация.ВводОстатковОПродажахЗаПрошлыеПериодыОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Автор = Пользователи.ТекущийПользователь();
	Ответственный = Пользователи.ТекущийПользователь();
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
	ВводОстатковЛокализация.ВводОстатковОПродажахЗаПрошлыеПериодыОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Автор = Пользователи.ТекущийПользователь();
	
	ОбщегоНазначенияУТ.ОчиститьИдентификаторыДокумента(ЭтотОбъект, "ОптовыеПродажи,РозничныеПродажи,ПодарочныеСертификаты");
	
	// Заполним ставку с учетом текущей даты документа. Пересчитываем связанные реквизиты табличной части.
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковОптовыхПродажЗаПрошлыеПериоды
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковРозничныхПродажЗаПрошлыеПериоды Тогда
		
		ВалютаРегламентированногоУчета            = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Организация);
		ВалютаУправленческогоУчета                = Константы.ВалютаУправленческогоУчета.Получить();
		КоэффициентПересчетаИзВалютыУпрВРегл      = РаботаСКурсамиВалютУТ.ПолучитьКоэффициентПересчетаИзВалютыВВалюту(
														ВалютаУправленческогоУчета,
														ВалютаРегламентированногоУчета,
														?(Дата = Дата(1,1,1), ТекущаяДатаСеанса(), Дата));
		
		СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПараметрыПересчетаСуммыНДСВТЧ(ЭтотОбъект);
		СтруктураДействийСтавкиНДС = Новый Структура;
		СтруктураДействийСтавкиНДС.Вставить("СкорректироватьСтавкуНДС", ОбработкаТабличнойЧастиКлиентСервер.ПараметрыЗаполненияСтавкиНДС(ЭтотОбъект));
		
		СтруктураДействий = Новый Структура;
		СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
		СтруктураДействий.Вставить("ПересчитатьСуммуБезНДС");
		СтруктураДействий.Вставить("ПересчитатьСуммуРегл", КоэффициентПересчетаИзВалютыУпрВРегл);
		СтруктураДействий.Вставить("ПересчитатьНДСРегл", СтруктураПересчетаСуммы);
		
		Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковОптовыхПродажЗаПрошлыеПериоды Тогда
			
			КэшированныеЗначения = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруКэшируемыеЗначения();
			ОбработкаТабличнойЧастиСервер.ОбработатьТЧ(ОптовыеПродажи, СтруктураДействийСтавкиНДС, КэшированныеЗначения);
			
			ОбработкаТабличнойЧастиСервер.ОбработатьТЧ(КэшированныеЗначения.ОбработанныеСтроки, СтруктураДействий, Неопределено);
		
		ИначеЕсли ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковРозничныхПродажЗаПрошлыеПериоды Тогда
			
			КэшированныеЗначения = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруКэшируемыеЗначения();
			ОбработкаТабличнойЧастиСервер.ОбработатьТЧ(РозничныеПродажи, СтруктураДействийСтавкиНДС, КэшированныеЗначения);
			
			ОбработкаТабличнойЧастиСервер.ОбработатьТЧ(КэшированныеЗначения.ОбработанныеСтроки, СтруктураДействий, Неопределено);
			
		КонецЕсли;
	
	КонецЕсли;
	
	ВводОстатковЛокализация.ВводОстатковОПродажахЗаПрошлыеПериодыПриКопировании(ЭтотОбъект, ОбъектКопирования);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
	ВводОстатковЛокализация.ВводОстатковОПродажахЗаПрошлыеПериодыПриЗаписи(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат
	КонецЕсли;
	
	ВводОстатковЛокализация.ВводОстатковОПродажахЗаПрошлыеПериодыПередУдалением(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)

	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") Тогда
		Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Организация) Тогда
		Валюта = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Организация);
	Иначе
		Валюта = ЗначениеНастроекПовтИсп.ВалютаУправленческогоУчета();
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		Если ДанныеЗаполнения.Свойство("ХозяйственнаяОперация") Тогда
			ХозяйственнаяОперация = ДанныеЗаполнения.ХозяйственнаяОперация;
		КонецЕсли;
		
		Если ДанныеЗаполнения.Свойство("Комментарий") Тогда
			Комментарий = ДанныеЗаполнения.Комментарий;
		КонецЕсли;
		
		Если ДанныеЗаполнения.Свойство("ЗначениеКопирования") Тогда
			ВводОстатковСервер.ЗаполнитьЗначенияПоСтаромуВводуОстатков(ЭтотОбъект, ДанныеЗаполнения.ЗначениеКопирования);
		КонецЕсли;
		
	КонецЕсли;
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковОптовыхПродажЗаПрошлыеПериоды
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковРозничныхПродажЗаПрошлыеПериоды Тогда
		
		Склад = ЗначениеНастроекПовтИсп.ПолучитьСкладПоУмолчанию(Склад);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ВидыЗапасов

Процедура ЗаполнитьВидыЗапасов()

	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТоваров.Номенклатура КАК Номенклатура,
	|	ТаблицаТоваров.ВидЗапасов КАК ВидЗапасов,
	|	ТаблицаТоваров.ГруппаПродукции КАК ГруппаПродукции
	|ПОМЕСТИТЬ ТаблицаТоваровВрем
	|ИЗ
	|	&ТаблицаТоваров КАК ТаблицаТоваров
	|
	|ГДЕ
	|	ТаблицаТоваров.ВидЗапасов = ЗНАЧЕНИЕ(Справочник.ВидыЗапасов.ПустаяСсылка)
	|	ИЛИ &ПерезаполнитьВидыЗапасов
	|;
	|
	|////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Т.НомерСтроки,
	|	Т.Номенклатура,
	|	Т.ВидЗапасов,
	|	Т.ГруппаПродукции
	|ПОМЕСТИТЬ ТаблицаТоваров
	|ИЗ
	|	ТаблицаТоваровВрем КАК Т
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СпрНоменклатура
	|	ПО Т.Номенклатура = СпрНоменклатура.Ссылка
	|		И ВЫБОР
	|			КОГДА &ХозяйственнаяОперация В (
	|				ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВводОстатковОптовыхПродажЗаПрошлыеПериоды),
	|				ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВводОстатковРозничныхПродажЗаПрошлыеПериоды))
	|			ТОГДА
	|				СпрНоменклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар)
	|				ИЛИ СпрНоменклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
	|			ИНАЧЕ ИСТИНА
	|			КОНЕЦ
	|;
	|
	|////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТоваров.Номенклатура КАК Номенклатура,
	|	ВЫБОР
	|		КОГДА &Проведен
	|			ТОГДА ТаблицаТоваров.ВидЗапасов
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ВидыЗапасов.ПустаяСсылка)
	|	КОНЕЦ КАК ТекущийВидЗапасов,
	|	ЛОЖЬ КАК ЭтоВозвратнаяТара,
	|	ТаблицаТоваров.ГруппаПродукции КАК ГруппаПродукции,
	|	НЕОПРЕДЕЛЕНО КАК ВидЦены,
	|	&Организация КАК Организация,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияКлиенту) КАК ХозяйственнаяОперация,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Товар) КАК ТипЗапасов,
	|	&Соглашение КАК Соглашение,
	|	&Валюта КАК Валюта,
	|	&НалогообложениеНДС КАК НалогообложениеНДС,
	|	НЕОПРЕДЕЛЕНО КАК ВладелецТовара,
	|	&Контрагент КАК Контрагент,
	|	&Договор КАК Договор,
	|	&НалогообложениеОрганизации КАК НалогообложениеОрганизации,
	|	ЛОЖЬ КАК ДеятельностьОблагаетсяЕНВД
	|ПОМЕСТИТЬ ИсходнаяТаблицаТоваров
	|ИЗ
	|	ТаблицаТоваров КАК ТаблицаТоваров
	|ГДЕ
	|	&ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВводОстатковОптовыхПродажЗаПрошлыеПериоды)
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТоваров.Номенклатура КАК Номенклатура,
	|	ВЫБОР
	|		КОГДА &Проведен
	|			ТОГДА ТаблицаТоваров.ВидЗапасов
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ВидыЗапасов.ПустаяСсылка)
	|	КОНЕЦ КАК ТекущийВидЗапасов,
	|	ЛОЖЬ КАК ЭтоВозвратнаяТара,
	|	ТаблицаТоваров.ГруппаПродукции КАК ГруппаПродукции,
	|	НЕОПРЕДЕЛЕНО КАК ВидЦены,
	|	&Организация КАК Организация,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияВРозницу) КАК ХозяйственнаяОперация,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Товар) КАК ТипЗапасов,
	|	&Соглашение КАК Соглашение,
	|	&Валюта КАК Валюта,
	|	&НалогообложениеНДС КАК НалогообложениеНДС,
	|	НЕОПРЕДЕЛЕНО КАК ВладелецТовара,
	|	&Контрагент КАК Контрагент,
	|	&Договор КАК Договор,
	|	&НалогообложениеОрганизации КАК НалогообложениеОрганизации,
	|	ЛОЖЬ КАК ДеятельностьОблагаетсяЕНВД
	|ИЗ
	|	ТаблицаТоваров КАК ТаблицаТоваров
	|ГДЕ
	|	&ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВводОстатковРозничныхПродажЗаПрошлыеПериоды)
	|;
	|////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ТаблицаТоваровВрем
	|;
	|////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ТаблицаТоваров
	|");

	МенеджерВременныхТаблиц        = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковОптовыхПродажЗаПрошлыеПериоды Тогда
		
		ТаблицаТоваров = ОптовыеПродажи.Выгрузить(, "НомерСтроки, Номенклатура, ВидЗапасов");
		ТаблицаТоваров.Колонки.Добавить("ГруппаПродукции", Новый ОписаниеТипов("СправочникСсылка.ГруппыАналитическогоУчетаНоменклатуры"));
		
	ИначеЕсли ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковРозничныхПродажЗаПрошлыеПериоды Тогда
		
		ТаблицаТоваров = РозничныеПродажи.Выгрузить(, "НомерСтроки, Номенклатура, ВидЗапасов");
		ТаблицаТоваров.Колонки.Добавить("ГруппаПродукции", Новый ОписаниеТипов("СправочникСсылка.ГруппыАналитическогоУчетаНоменклатуры"));
		
	КонецЕсли;
	
	Запрос.УстановитьПараметр("ТаблицаТоваров",        ТаблицаТоваров);
	Запрос.УстановитьПараметр("Организация",           Организация);
	Запрос.УстановитьПараметр("ХозяйственнаяОперация", ХозяйственнаяОперация);
	Запрос.УстановитьПараметр("Партнер",               Партнер);
	Запрос.УстановитьПараметр("Контрагент",            Контрагент);
	Запрос.УстановитьПараметр("Подразделение",         Подразделение);
	Запрос.УстановитьПараметр("Менеджер",              Менеджер);
	Запрос.УстановитьПараметр("Договор",               Договор);
	Запрос.УстановитьПараметр("Валюта",                Валюта);
	Запрос.УстановитьПараметр("Проведен",              Проведен);
	Запрос.УстановитьПараметр("НалогообложениеНДС",    НалогообложениеНДС);
	
	Если ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.ВводОстатковОптовыхПродажЗаПрошлыеПериоды Тогда
		Запрос.УстановитьПараметр("Соглашение", Справочники.СоглашенияСПоставщиками.ПустаяСсылка());
	Иначе
		Запрос.УстановитьПараметр("Соглашение", СоглашениеСКлиентом);
	КонецЕсли;
	
	
	ПараметрыУчетаПоОрганизации = УчетНДСУП.ПараметрыУчетаПоОрганизации(Организация, Дата);
	
	Запрос.УстановитьПараметр("НалогообложениеОрганизации",
		ПараметрыУчетаПоОрганизации.ОсновноеНалогообложениеНДСПродажи);
	
	ЗапасыСервер.ДополнитьВременныеТаблицыОбязательнымиКолонками(Запрос);
	ЗапасыСервер.ПроверитьНеобходимостьПерезаполненияВидовЗапасовДокумента(ЭтотОбъект, Запрос);
	
	Запрос.Выполнить();
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковОптовыхПродажЗаПрошлыеПериоды Тогда
		ЗапасыСервер.ЗаполнитьВидыЗапасовПоУмолчанию(МенеджерВременныхТаблиц, ОптовыеПродажи);
	ИначеЕсли ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковРозничныхПродажЗаПрошлыеПериоды Тогда
		ЗапасыСервер.ЗаполнитьВидыЗапасовПоУмолчанию(МенеджерВременныхТаблиц, РозничныеПродажи);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура ДополнитьПроверяемыеРеквизиты(ПроверяемыеРеквизиты)
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковОптовыхПродажЗаПрошлыеПериоды Тогда
		МассивНоменклатуры = ОптовыеПродажи.ВыгрузитьКолонку("Номенклатура");
	ИначеЕсли ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковРозничныхПродажЗаПрошлыеПериоды Тогда
		МассивНоменклатуры = РозничныеПродажи.ВыгрузитьКолонку("Номенклатура");
	Иначе
		МассивНоменклатуры = Неопределено;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(МассивНоменклатуры) Тогда
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("МассивНоменклатуры", МассивНоменклатуры);
		Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ИСТИНА
		|ИЗ
		|	Справочник.Номенклатура КАК ТаблицаНоменклатуры
		|ГДЕ
		|	Ссылка В (&МассивНоменклатуры)
		|	И ТипНоменклатуры В (ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар),
		|		ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара))";
		
		РезультатЗапроса = Запрос.Выполнить();
		Если Не РезультатЗапроса.Пустой() Тогда
			ПроверяемыеРеквизиты.Добавить("Склад");
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура СоздатьКартыЛояльностиИЗаполнитьАналитикуУчетаПоПартнерам();
	
	СтруктураДанныхКартыЛояльности = КартыЛояльностиСервер.ИнициализироватьДанныеКартыЛояльности();
	Для Каждого ТекСтрока Из РозничныеПродажи Цикл
		Если НЕ ЗначениеЗаполнено(ТекСтрока.КартаЛояльности) И ЗначениеЗаполнено(ТекСтрока.ВидКартыЛояльности) Тогда
			Результат = КартыЛояльностиСервер.НайтиКартыЛояльности(ТекСтрока.ШтрихКод, Перечисления.ТипыКодовКарт.Штрихкод);
			Для Каждого Стр Из Результат.ЗарегистрированныеКартыЛояльности Цикл
				Если Стр.МагнитныйКод = ТекСтрока.МагнитныйКод И Стр.ВидКарты = ТекСтрока.ВидКартыЛояльности Тогда
					ТекСтрока.КартаЛояльности = Стр.Ссылка;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Если НЕ ЗначениеЗаполнено(ТекСтрока.КартаЛояльности) Тогда
				СтруктураДанныхКартыЛояльности.ВидКарты = ТекСтрока.ВидКартыЛояльности;
				СтруктураДанныхКартыЛояльности.Штрихкод = ТекСтрока.ШтрихКод;
				СтруктураДанныхКартыЛояльности.МагнитныйКод = ТекСтрока.МагнитныйКод;
				НоваяКарта = КартыЛояльностиСервер.СоздатьПартнераИЗарегистрироватьКартуЛояльности(СтруктураДанныхКартыЛояльности);
				ТекСтрока.КартаЛояльности = НоваяКарта;
			КонецЕсли;
		КонецЕсли;
		Реквизиты = Новый Структура;
		Реквизиты.Вставить("Организация", Организация);
		Реквизиты.Вставить("Партнер", КартыЛояльностиВызовСервера.ПолучитьДанныеКартыЛояльности(ТекСтрока.КартаЛояльности).Партнер);
		Реквизиты.Вставить("Контрагент", Справочники.Контрагенты.ПустаяСсылка());
		Реквизиты.Вставить("Договор", Справочники.ДоговорыКонтрагентов.ПустаяСсылка());
		Реквизиты.Вставить("НаправлениеДеятельности", Справочники.НаправленияДеятельности.ПустаяСсылка());
		ТекСтрока.АналитикаУчетаПоПартнерам = РегистрыСведений.АналитикаУчетаПоПартнерам.ЗначениеКлючаАналитики(Реквизиты);
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьАналитикуУчетаПоПартнерам()
	
	Для Каждого ТекСтрока Из РозничныеПродажи Цикл
		Реквизиты = Новый Структура;
		Реквизиты.Вставить("Организация", Организация);
		Реквизиты.Вставить("Партнер", Справочники.Партнеры.ПустаяСсылка());
		Реквизиты.Вставить("Контрагент", Справочники.Контрагенты.ПустаяСсылка());
		Реквизиты.Вставить("Договор", Справочники.ДоговорыКонтрагентов.ПустаяСсылка());
		Реквизиты.Вставить("НаправлениеДеятельности", Справочники.НаправленияДеятельности.ПустаяСсылка());
		ТекСтрока.АналитикаУчетаПоПартнерам = РегистрыСведений.АналитикаУчетаПоПартнерам.ЗначениеКлючаАналитики(Реквизиты);
	КонецЦикла;
	
КонецПроцедуры

Процедура СоздатьПодарочныеСертификаты(Отказ)
	
	УстановитьПривилегированныйРежим(Истина);
	
	НовыеЭлементы = Новый Массив;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Таблица.Штрихкод КАК Штрихкод,
	|	Таблица.МагнитныйКод КАК МагнитныйКод,
	|	Таблица.НомерСтроки КАК НомерСтроки,
	|	Таблица.СерийныйНомер КАК СерийныйНомер
	|ПОМЕСТИТЬ Таблица
	|ИЗ
	|	&ПодарочныеСертификаты КАК Таблица
	|;
	|
	|ВЫБРАТЬ
	|	Таблица.НомерСтроки КАК НомерСтроки,
	|	ЕСТЬNULL(СправочникПодарочныеСертификатыПоШтрихкоду.Ссылка,      ЗНАЧЕНИЕ(Справочник.ПодарочныеСертификаты.ПустаяСсылка)) КАК ПодарочныйСертификатПоШтрихкоду,
	|	ЕСТЬNULL(СправочникПодарочныеСертификатыПоМагнитномуКоду.Ссылка, ЗНАЧЕНИЕ(Справочник.ПодарочныеСертификаты.ПустаяСсылка)) КАК ПодарочныйСертификатПоМагнитномуКоду,
	|	ЕСТЬNULL(СправочникПодарочныйСертификатПоСерийномуНомеру.Ссылка, ЗНАЧЕНИЕ(Справочник.ПодарочныеСертификаты.ПустаяСсылка)) КАК ПодарочныйСертификатПоСерийномуНомеру
	|ИЗ
	|	Таблица КАК Таблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПодарочныеСертификаты КАК СправочникПодарочныеСертификатыПоШтрихкоду
	|		ПО СправочникПодарочныеСертификатыПоШтрихкоду.Штрихкод = Таблица.Штрихкод
	|		И СправочникПодарочныеСертификатыПоШтрихкоду.Владелец = &ВидПодарочногоСертификата
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПодарочныеСертификаты КАК СправочникПодарочныеСертификатыПоМагнитномуКоду
	|		ПО СправочникПодарочныеСертификатыПоМагнитномуКоду.МагнитныйКод = Таблица.МагнитныйКод
	|		И СправочникПодарочныеСертификатыПоМагнитномуКоду.Владелец = &ВидПодарочногоСертификата
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПодарочныеСертификаты КАК СправочникПодарочныйСертификатПоСерийномуНомеру
	|		ПО СправочникПодарочныйСертификатПоСерийномуНомеру.Код = Таблица.СерийныйНомер
	|");
	
	Запрос.УстановитьПараметр("ВидПодарочногоСертификата", ВидПодарочногоСертификата);
	Запрос.УстановитьПараметр("ПодарочныеСертификаты",     ПодарочныеСертификаты.Выгрузить());
	
	Таблица = Запрос.Выполнить().Выгрузить();
	ТипКарты = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидПодарочногоСертификата, "ТипКарты");
	
	Для Каждого СтрокаТЧ Из ПодарочныеСертификаты Цикл
		
		Если Не ЗначениеЗаполнено(СтрокаТЧ.ПодарочныйСертификат) Тогда
			
			НайденнаяСтрока = Таблица.НайтиСтроки(Новый Структура("НомерСтроки", СтрокаТЧ.НомерСтроки))[0];
			
			Если ТипКарты = Перечисления.ТипыКарт.Штриховая Тогда
				
				Если ЗначениеЗаполнено(НайденнаяСтрока.ПодарочныйСертификатПоСерийномуНомеру)
					И ЗначениеЗаполнено(НайденнаяСтрока.ПодарочныйСертификатПоШтрихкоду)
					И НайденнаяСтрока.ПодарочныйСертификатПоСерийномуНомеру = НайденнаяСтрока.ПодарочныйСертификатПоШтрихкоду Тогда
					СтрокаТЧ.ПодарочныйСертификат = НайденнаяСтрока.ПодарочныйСертификатПоСерийномуНомеру;
					Продолжить;
				КонецЕсли;
				
			ИначеЕсли ТипКарты = Перечисления.ТипыКарт.Магнитная Тогда
				
				Если ЗначениеЗаполнено(НайденнаяСтрока.ПодарочныйСертификатПоСерийномуНомеру)
					И ЗначениеЗаполнено(НайденнаяСтрока.ПодарочныйСертификатПоМагнитномуКоду)
					И НайденнаяСтрока.ПодарочныйСертификатПоСерийномуНомеру = НайденнаяСтрока.ПодарочныйСертификатПоМагнитномуКоду Тогда
					СтрокаТЧ.ПодарочныйСертификат = НайденнаяСтрока.ПодарочныйСертификатПоСерийномуНомеру;
					Продолжить;
				КонецЕсли;
				
			Иначе
				
				Если ЗначениеЗаполнено(НайденнаяСтрока.ПодарочныйСертификатПоСерийномуНомеру)
					И ЗначениеЗаполнено(НайденнаяСтрока.ПодарочныйСертификатПоШтрихкоду)
					И ЗначениеЗаполнено(НайденнаяСтрока.ПодарочныйСертификатПоМагнитномуКоду)
					И НайденнаяСтрока.ПодарочныйСертификатПоСерийномуНомеру = НайденнаяСтрока.ПодарочныйСертификатПоМагнитномуКоду
					И НайденнаяСтрока.ПодарочныйСертификатПоСерийномуНомеру = НайденнаяСтрока.ПодарочныйСертификатПоШтрихкоду Тогда
					СтрокаТЧ.ПодарочныйСертификат = НайденнаяСтрока.ПодарочныйСертификатПоСерийномуНомеру;
					Продолжить;
				КонецЕсли;
				
			КонецЕсли;
			
			Попытка
				
				СтруктураДанныхПодарочногоСертификата = ПодарочныеСертификатыВызовСервера.ИнициализироватьОписаниеПодарочногоСертификата();
				СтруктураДанныхПодарочногоСертификата.ВидПодарочногоСертификата = ВидПодарочногоСертификата;
				СтруктураДанныхПодарочногоСертификата.МагнитныйКод              = СтрокаТЧ.МагнитныйКод;
				СтруктураДанныхПодарочногоСертификата.Штрихкод                  = СтрокаТЧ.Штрихкод;
				СтруктураДанныхПодарочногоСертификата.СерийныйНомер             = СтрокаТЧ.СерийныйНомер;
				СтрокаТЧ.ПодарочныйСертификат = ПодарочныеСертификатыСервер.ЗарегистрироватьПодарочныйСертификат(СтруктураДанныхПодарочногоСертификата);
				
				НовыеЭлементы.Добавить(СтрокаТЧ);
				
			Исключение
				
				ТекстСообщения = НСтр("ru = 'Ошибка создания подарочного сертификата: ""%ОписаниеОшибки%""';
										|en = 'Error creating gift card: ""%ОписаниеОшибки%""'");
				Информация = ИнформацияОбОшибке();
				Если Информация.Причина <> Неопределено Тогда
					ТекстОшибки = Информация.Причина.Описание;
				Иначе
					ТекстОшибки = ПодробноеПредставлениеОшибки(Информация);
				КонецЕсли;
				ТекстСообщения = СтрЗаменить(ТекстСообщения,"%ОписаниеОшибки%",ТекстОшибки);
				ОбщегоНазначения.СообщитьПользователю(
					ТекстСообщения,
					,
					"Объект.ПодарочныеСертификаты" + "[" + Формат(СтрокаТЧ.НомерСтроки - 1,"ЧГ=0") + "].СерийныйНомер",
					,
					Отказ);
				Прервать;
				
			КонецПопытки;
			
		КонецЕсли;
	КонецЦикла;
	
	Если Отказ Тогда
		Для Каждого СтрокаТЧ Из НовыеЭлементы Цикл
			СтрокаТЧ.ПодарочныйСертификат = Неопределено;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
