#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ИнтеграцияЗЕРНОПереопределяемый.ОбработкаЗаполненияДокумента(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	
	ЗаполнитьОбъектПоСтатистике();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если Не ИнтеграцияЗЕРНОКлиентСервер.ТребуетсяЗаполнениеКодаТНВЭД(НазначениеПартии) Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("Сырье.КодТНВЭД");
		МассивНепроверяемыхРеквизитов.Добавить("КодТНВЭД");
		МассивНепроверяемыхРеквизитов.Добавить("СтранаНазначения");
		
	КонецЕсли;
	
	Если ИнтеграцияЗЕРНО.ОпределитьТипОрганизацияКонтрагент(Товаропроизводитель) = 0 Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товаропроизводитель");
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Номенклатура) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Количество");
	КонецЕсли;
	
	ВыполнятьПроверкуПотребительскихСвойств = Истина;
	Если ЗначениеЗаполнено(Ссылка) Тогда
		ТекущееСостояние = РегистрыСведений.СтатусыОбъектовСинхронизацииЗЕРНО.ТекущееСостояние(Ссылка);
		КонечныеСтатусы = Документы.ФормированиеПартийПриПроизводствеЗЕРНО.КонечныеСтатусы(Ложь);
		Если КонечныеСтатусы.Найти(ТекущееСостояние.Статус) <> Неопределено Тогда
			ВыполнятьПроверкуПотребительскихСвойств = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если ВыполнятьПроверкуПотребительскихСвойств Тогда
		
		ТаблицаОшибок = ПустыеПотребительскиеСвойстваПродукцииПоДокументу();
		
		Для Каждого СтрокаТаблицы Из ТаблицаОшибок Цикл
			
			ТекстСообщения = СтрШаблон(НСтр("ru = 'В строке %1 значение потребительского свойства %2 вне допустимого диапазона.';
											|en = 'В строке %1 значение потребительского свойства %2 вне допустимого диапазона.'"),
				СтрокаТаблицы.НомерСтроки,
				СтрокаТаблицы.ПотребительскоеСвойство);
			
			ОбщегоНазначения.СообщитьПользователю(
				ТекстСообщения,
				ЭтотОбъект, 
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(
					"ПотребительскиеСвойства", СтрокаТаблицы.НомерСтроки, "Значение"),, Отказ);
			
		КонецЦикла;
		
	КонецЕсли;
	
	ИнтеграцияЗЕРНОПереопределяемый.ПриОпределенииОбработкиПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	Если ИнтеграцияЗЕРНО.ОпределитьТипОрганизацияКонтрагент(Товаропроизводитель) = 1 Тогда
		ПодразделениеТоваропроизводителя = ОбщегоНазначенияИС.ПустоеЗначениеОпределяемогоТипа("Подразделение");
	КонецЕсли;
	
	ИнтеграцияЗЕРНО.ЗаписатьСоответствиеНоменклатуры(ЭтотОбъект, "Шапка");
	ИнтеграцияИСПереопределяемый.ПередЗаписьюОбъекта(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	ИнтеграцияЗЕРНО.ЗаписатьСтатусДокументаЗЕРНОПоУмолчанию(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Партия = Неопределено;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа
	ИнтеграцияИС.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	// Инициализация данных документа
	Документы.ФормированиеПартийПриПроизводствеЗЕРНО.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ИнтеграцияИС.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	РегистрыНакопления.ОстаткиПартийЗЕРНО.ОтразитьДвижения(ДополнительныеСвойства, Движения, Отказ);
	ИнтеграцияИСПереопределяемый.ОтразитьДвижения(ДополнительныеСвойства, Движения, Отказ);
	
	ИнтеграцияИС.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ИнтеграцияИСПереопределяемый.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);
	
	ИнтеграцияИС.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбработкаЗаполнения

Процедура ЗаполнитьОбъектПоСтатистике()
	
	ДанныеСтатистики = ЗаполнениеОбъектовПоСтатистикеЗЕРНО.ДанныеЗаполненияФормированиеПартийПриПроизводствеЗЕРНО(Организация);
	
	Для Каждого КлючИЗначение Из ДанныеСтатистики Цикл
		ЗаполнениеОбъектовПоСтатистикеЗЕРНО.ЗаполнитьПустойРеквизит(ЭтотОбъект, ДанныеСтатистики, КлючИЗначение.Ключ);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

Функция ПустыеПотребительскиеСвойстваПродукцииПоДокументу()
	
	ТаблицаПотребительскиеСвойства = ПотребительскиеСвойства.Выгрузить(, "НомерСтроки, ПотребительскоеСвойство, Значение");
	
	НазначениеПотребительскогоСвойства = ИнтеграцияЗЕРНО.НазначениеПотребительскогоСвойстваДаннымПартии(НазначениеПартии);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПотребительскиеСвойства.НомерСтроки             КАК НомерСтроки,
	|	ПотребительскиеСвойства.ПотребительскоеСвойство КАК ПотребительскоеСвойство,
	|	ПотребительскиеСвойства.Значение                КАК Значение
	|ПОМЕСТИТЬ ВТ_ПотребительскиеСвойства
	|ИЗ
	|	&ПотребительскиеСвойства КАК ПотребительскиеСвойства
	|;
	|/////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПотребительскиеСвойства.НомерСтроки                            КАК НомерСтроки,
	|	ПРЕДСТАВЛЕНИЕ(ПотребительскиеСвойства.ПотребительскоеСвойство) КАК ПотребительскоеСвойство
	|ИЗ
	|	ВТ_ПотребительскиеСвойства КАК ПотребительскиеСвойства
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ДопустимыеЗначенияПотребительскихСвойствЗЕРНО КАК ДопустимыеЗначенияПотребительскихСвойствЗЕРНО
	|		ПО (ПотребительскиеСвойства.ПотребительскоеСвойство = ДопустимыеЗначенияПотребительскихСвойствЗЕРНО.ПотребительскоеСвойство)
	|		И ДопустимыеЗначенияПотребительскихСвойствЗЕРНО.ОКПД2 = &ОКПД2
	|		И (ДопустимыеЗначенияПотребительскихСвойствЗЕРНО.Назначение = &Назначение)
	|		И (ДопустимыеЗначенияПотребительскихСвойствЗЕРНО.ДействуетПо >= &Дата
	|		ИЛИ ДопустимыеЗначенияПотребительскихСвойствЗЕРНО.ДействуетПо = ДАТАВРЕМЯ(1, 1, 1))
	|		И (ДопустимыеЗначенияПотребительскихСвойствЗЕРНО.КодСтраны = &КодСтраны)
	|		И (ДопустимыеЗначенияПотребительскихСвойствЗЕРНО.ТипЗначения = ЗНАЧЕНИЕ(Перечисление.ТипыЗначенияПотребительскогоСвойстваЗЕРНО.Число)
	|			И (ПотребительскиеСвойства.Значение < ДопустимыеЗначенияПотребительскихСвойствЗЕРНО.ДиапазонС
	|				ИЛИ ДопустимыеЗначенияПотребительскихСвойствЗЕРНО.ДиапазонПо > 0
	|				И ПотребительскиеСвойства.Значение > ДопустимыеЗначенияПотребительскихСвойствЗЕРНО.ДиапазонПо)
	|			ИЛИ ДопустимыеЗначенияПотребительскихСвойствЗЕРНО.ТипЗначения = ЗНАЧЕНИЕ(Перечисление.ТипыЗначенияПотребительскогоСвойстваЗЕРНО.Перечисление)
	|				И ПотребительскиеСвойства.Значение = """"
	|				И ВЫРАЗИТЬ(ДопустимыеЗначенияПотребительскихСвойствЗЕРНО.ДопустимыеЗначения КАК СТРОКА(1)) <> """")";
	
	Запрос.УстановитьПараметр("ОКПД2",                   ОКПД2);
	Запрос.УстановитьПараметр("ПотребительскиеСвойства", ТаблицаПотребительскиеСвойства);
	
	Запрос.УстановитьПараметр("Назначение", НазначениеПотребительскогоСвойства);
	Запрос.УстановитьПараметр("Дата",       ТекущаяУниверсальнаяДата());
	Запрос.УстановитьПараметр("КодСтраны", "RU");
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

#КонецОбласти

#КонецЕсли
