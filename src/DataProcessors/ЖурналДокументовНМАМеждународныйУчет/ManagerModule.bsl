#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Определяет состав документов и хозяйственных операций, доступных для отображения в рабочем месте.
//
// Параметры:
//  ХозяйственныеОперацииИДокументы	 - ТаблицаЗначений - таблица значений с колонками:
//     * ХозяйственнаяОперация					 - ПеречислениеСсылка.ХозяйственныеОперации
//     * ИдентификаторОбъектаМетаданных			 - СправочникСсылка.ИдентификаторыОбъектовМетаданных
//     * Отбор									 - Булево
//     * ДокументПредставление					 - Строка
//     * ПолноеИмяДокумента						 - Строка
//     * Накладная								 - Булево
//     * ИспользуетсяРаспоряжение				 - Булево
//     * ИспользуютсяСтатусы					 - Булево
//     * ПоНесколькимЗаказам					 - Булево
//     * ПриходныйОрдерНевозможен				 - Булево
//     * РазделятьДокументыПоПодразделению		 - Булево
//     * ПолноеИмяНакладной						 - Строка
//     * КлючНазначенияИспользования			 - Строка
//     * ПравоДоступаДобавление					 - Булево
//     * ПравоДоступаИзменение					 - Булево
//     * ЗаголовокРабочегоМеста					 - Строка
//     * ИменаЭлементовСУправляемойВидимостью	 - Строка
//     * ИменаЭлементовРабочегоМеста			 - Строка
//     * ИменаОтображаемыхЭлементов				 - Строка
//     * МенеджерРасчетаГиперссылкиКОформлению	 - Строка
//  ОтборХозяйственныеОперации		 - СписокЗначений - список значений типа ПеречислениеСсылка.ХозяйственныеОперации
//  ОтборТипыДокументов				 - СписокЗначений - список значений типа СправочникСсылка.ИдентификаторыОбъектовМетаданных
//  КлючНазначенияИспользования		 - Строка - ключ рабочего места для которого вызывается функция
//  ДокументыКОформлению			 - Булево - признак вызова метода для формы "ФормаСпискаКОформлению".
// 
// Возвращаемое значение:
//   - ТаблицаЗначений - таблица значений с колонками:
//     * ХозяйственнаяОперация					 - ПеречислениеСсылка.ХозяйственныеОперации
//     * ИдентификаторОбъектаМетаданных			 - СправочникСсылка.ИдентификаторыОбъектовМетаданных
//     * Отбор									 - Булево
//     * ДокументПредставление					 - Строка
//     * ПолноеИмяДокумента						 - Строка
//     * Накладная								 - Булево
//     * ИспользуетсяРаспоряжение				 - Булево
//     * ИспользуютсяСтатусы					 - Булево
//     * ПоНесколькимЗаказам					 - Булево
//     * ПриходныйОрдерНевозможен				 - Булево
//     * РазделятьДокументыПоПодразделению		 - Булево
//     * ПолноеИмяНакладной						 - Строка
//     * КлючНазначенияИспользования			 - Строка
//     * ПравоДоступаДобавление					 - Булево
//     * ПравоДоступаИзменение					 - Булево
//     * ЗаголовокРабочегоМеста					 - Строка
//     * ИменаЭлементовСУправляемойВидимостью	 - Строка
//     * ИменаЭлементовРабочегоМеста			 - Строка
//     * ИменаОтображаемыхЭлементов				 - Строка
//     * МенеджерРасчетаГиперссылкиКОформлению	 - Строка.
//
//
Функция ИнициализироватьХозяйственныеОперацииИДокументы(ХозяйственныеОперацииИДокументы, ОтборХозяйственныеОперации, ОтборТипыДокументов, КлючНазначенияИспользования, ДокументыКОформлению = Ложь) Экспорт
	
	// ВыработкаНМА
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	Строка.ХозяйственнаяОперация        = Перечисления.ХозяйственныеОперации.ВыработкаНМА;
	Строка.ПолноеИмяДокумента           = Метаданные.Документы.ВыработкаНМА.ПолноеИмя();
	Строка.КлючНазначенияИспользования  = "МеждународныйУчет";
	Строка.Порядок                      = 4;
	Строка.ДобавитьКнопкуСоздать        = Истина;
	
	// ИзменениеПараметровНМАМеждународныйУчет
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	Строка.ХозяйственнаяОперация        = Перечисления.ХозяйственныеОперации.ИзменениеПараметровНМА;
	Строка.ПолноеИмяДокумента           = Метаданные.Документы.ИзменениеПараметровНМАМеждународныйУчет.ПолноеИмя();
	Строка.ДокументПредставление        = НСтр("ru = 'Изменение параметров НМА';
												|en = 'Adjust intangible asset financial details'");
	Строка.КлючНазначенияИспользования  = "МеждународныйУчет";
	Строка.Порядок                      = 2;
	Строка.ДобавитьКнопкуСоздать        = Истина;
	
	// ПеремещениеНМАМеждународныйУчет
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	Строка.ХозяйственнаяОперация        = Перечисления.ХозяйственныеОперации.ПеремещениеНМА;
	Строка.ПолноеИмяДокумента           = Метаданные.Документы.ПеремещениеНМАМеждународныйУчет.ПолноеИмя();
	Строка.ДокументПредставление        = НСтр("ru = 'Перемещение НМА';
												|en = 'Transfer intangible assets'");
	Строка.КлючНазначенияИспользования  = "МеждународныйУчет";
	Строка.Порядок                      = 3;
	Строка.ДобавитьКнопкуСоздать        = Истина;
	
	// ПринятиеКУчетуНМАМеждународныйУчет
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	Строка.ХозяйственнаяОперация        = Перечисления.ХозяйственныеОперации.ПринятиеКУчетуНМА;
	Строка.ПолноеИмяДокумента           = Метаданные.Документы.ПринятиеКУчетуНМАМеждународныйУчет.ПолноеИмя();
	Строка.ДокументПредставление        = НСтр("ru = 'Принятие к учету НМА';
												|en = 'Intangible assets — Initial recognition'");
	Строка.КлючНазначенияИспользования  = "МеждународныйУчет";
	Строка.Порядок                      = 1;
	Строка.ДобавитьКнопкуСоздать        = Истина;
	
	// СписаниеНМАМеждународныйУчет
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	Строка.ХозяйственнаяОперация        = Перечисления.ХозяйственныеОперации.СписаниеНМА;
	Строка.ПолноеИмяДокумента           = Метаданные.Документы.СписаниеНМАМеждународныйУчет.ПолноеИмя();
	Строка.ДокументПредставление        = НСтр("ru = 'Списание НМА';
												|en = 'Dispose intangible assets'");
	Строка.КлючНазначенияИспользования  = "МеждународныйУчет";
	Строка.Порядок                      = 5;
	Строка.ДобавитьКнопкуСоздать        = Истина;

	
	ТаблицаЗначенийДоступно = ОбщегоНазначенияУТ.ДоступныеХозяйственныеОперацииИДокументы(
								ХозяйственныеОперацииИДокументы, 
								ОтборХозяйственныеОперации, 
								ОтборТипыДокументов, 
								КлючНазначенияИспользования);
	
	Возврат ТаблицаЗначенийДоступно;
	
КонецФункции

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//   Параметры - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.Параметры
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция КлючНазначенияФормыПоУмолчанию() Экспорт
	
	Возврат "МеждународныйУчет";
	
КонецФункции

#КонецОбласти

#КонецЕсли