////////////////////////////////////////////////////////////////////////////////
// Процедуры, связанные с расчетом амортизации НМА
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ЗакрытиеМесяца

// Добавляет этап в таблицу этапов закрытия месяца.
// Элементы данной таблицы являются элементами второго уровня в дереве этапов в форме закрытия месяца.
// 
// Параметры:
// 	ТаблицаЭтапов - (См. Обработки.ОперацииЗакрытияМесяца.ЗаполнитьОписаниеЭтаповЗакрытияМесяца)
// 	ТекущийРодитель - Строка - идентификатор группы.
Процедура ДобавитьЭтап(ТаблицаЭтапов,ТекущийРодитель) Экспорт
	
	НоваяСтрока = ЗакрытиеМесяцаСервер.ДобавитьЭтапВТаблицу(ТаблицаЭтапов, ТекущийРодитель,
		Перечисления.ОперацииЗакрытияМесяца.НачислениеАмортизацииНМА);
		
	НоваяСтрока.ПредшествующиеЭтапы.Добавить(Перечисления.ОперацииЗакрытияМесяца.ПереходНаУчетВнеоборотныхАктивовВерсии24);
	НоваяСтрока.ПредшествующиеЭтапы.Добавить(Перечисления.ОперацииЗакрытияМесяца.АктуализацияПараметровУзловКомпонентовАмортизации);
	
	НоваяСтрока.ТекстВыполнить = НСтр("ru = 'Начислить';
										|en = 'Charge'");
	
	НоваяСтрока.ДействиеИспользование = ЗакрытиеМесяцаСервер.ОписаниеДействия_СервернаяПроцедура(
		"РасчетАмортизацииНМА.ОпределитьСтатусОперацииЗакрытияМесяца");
		
	НоваяСтрока.ДействиеВыполнить  = ЗакрытиеМесяцаСервер.ОписаниеДействия_ВыполнитьРасчет(
		"РасчетАмортизацииНМА.ВыполнитьОперациюЗакрытияМесяца");
		
	НоваяСтрока.ДействиеПодробнее = ЗакрытиеМесяцаСервер.ОписаниеДействия_КлиентскаяПроцедура(
		"ВнеоборотныеАктивыКлиент.ОбработкаДействияПодробнееФормыЗакрытияМесяцаЭтапаНачислениеАмортизацииНМА");
	
КонецПроцедуры

// Опредяет статус операции "НачислениеАмортизацииНМА".
// 
// Параметры:
//  ПараметрыОбработчика - Структура - Параметры обработчика
Процедура ОпределитьСтатусОперацииЗакрытияМесяца(ПараметрыОбработчика) Экспорт
	
	ЗакрытиеМесяцаСервер.УвеличитьКоличествоОбработанныхДанныхДляЗамера(ПараметрыОбработчика, 1);
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьВнеоборотныеАктивы2_2")
		И НЕ ПолучитьФункциональнуюОпцию("ИспользоватьВнеоборотныеАктивы2_4") Тогда
		
		ЗакрытиеМесяцаСервер.УстановитьСостояниеОтключено(
			ПараметрыОбработчика,
			НСтр("ru = 'Учет внеоборотных активов отключен.';
				|en = 'Accounting of fixed assets disabled.'", ОбщегоНазначения.КодОсновногоЯзыка()));
		
		Возврат;
		
	КонецЕсли;
	
	Если ЗакрытиеМесяцаСервер.ПроверитьНаличиеЗаданийКЗакрытиюМесяца(ПараметрыОбработчика,Истина,, "ЗаданияКРасчетуАмортизацииНМА") Тогда
		Возврат;
	КонецЕсли;
	
	ЗакрытиеМесяцаСервер.УвеличитьКоличествоОбработанныхДанныхДляЗамера(ПараметрыОбработчика, 1);
	
	Если ВнеоборотныеАктивы.ИспользуетсяУправлениеВНА_2_4(ПараметрыОбработчика.ПараметрыРасчета.НачалоПериода) Тогда
		ИмяДокумента = Метаданные.Документы.АмортизацияНМА2_4.Имя;
	Иначе
		ИмяДокумента = ВнеоборотныеАктивыЛокализация.ИмяДокументаАмортизацияНМА();
	КонецЕсли; 
	
	ЗакрытиеМесяцаСервер.ПроверитьНаличиеРегламентногоДокументаЭтапаЗакрытияМесяца(ПараметрыОбработчика, ИмяДокумента);
	
КонецПроцедуры

// Выполняет операцию "НачислениеАмортизацииНМА".
// 
// Параметры:
//  ПараметрыОбработчика - Структура - Параметры обработчика
Процедура ВыполнитьОперациюЗакрытияМесяца(ПараметрыОбработчика) Экспорт
	
	ОписаниеЗамера = ОценкаПроизводительности.НачатьЗамерДлительнойОперации("ЗакрытиеМесяца.НачислениеАмортизацииНМА");

	ПараметрыРасчета = ПараметрыОбработчика.ПараметрыРасчета;
	
	КоличествоДанных = 0;
	
	Попытка
		
		РегистрыСведений.ПакетыАмортизацииНМА.СоздатьПакетыАмортизации(ПараметрыРасчета.МассивОрганизаций);
		
		КонецРасчета = КонецМесяца(ПараметрыРасчета.Период);
		НачалоРасчета = РегистрыСведений.ЗаданияКРасчетуАмортизацииНМА.НачалоРасчета(ПараметрыРасчета.МассивОрганизаций);
		
		Результат = ВыполнитьОперацию(
			НачалоРасчета, 
			КонецРасчета, 
			ПараметрыРасчета.МассивОрганизаций,
			ПараметрыОбработчика.ИдентификаторРасчета);
			
		КоличествоДанных = Результат.КоличествоДанных;
		
	Исключение
		
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ТекстОшибки = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
		
		Для Каждого Организация Из ПараметрыРасчета.МассивОрганизаций Цикл
			
			ВнеоборотныеАктивыСлужебный.ЗарегистрироватьПроблемуВыполненияРасчета(
				Перечисления.ОперацииЗакрытияМесяца.НачислениеАмортизацииНМА, 
				ПараметрыРасчета.Период,
				Организация,
				ТекстОшибки);
		
		КонецЦикла;
		
	КонецПопытки;

	ОценкаПроизводительности.ЗакончитьЗамерДлительнойОперации(ОписаниеЗамера, КоличествоДанных);
	
КонецПроцедуры

// Формирует описание технологических параметров.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Описание параметров операции закрытия месяца
Функция ОписаниеПараметровОперацииЗакрытияМесяца() Экспорт
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьВнеоборотныеАктивы2_4") Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ОписаниеПараметров = Константы.НастройкиЗакрытияМесяца.СоздатьМенеджерЗначения().ИнициализироватьОписаниеПараметровОперации();
	
	#Область МаксимальноеКоличествоЗаданий
		
	ОписаниеПараметра = ОписаниеПараметров.Добавить();
	ОписаниеПараметра.Имя = "МаксимальноеКоличествоЗаданий";
	ОписаниеПараметра.Наименование = НСтр("ru = 'Количество одновременно выполняемых заданий (потоков) расчета амортизации';
											|en = 'Number of simultaneous depreciation calculation jobs (threads)'");
	ОписаниеПараметра.ТипЗначения = Новый ОписаниеТипов("Число",,, Новый КвалификаторыЧисла(2, 0, ДопустимыйЗнак.Неотрицательный));
	ОписаниеПараметра.ДиапазонС = 1;
	ОписаниеПараметра.ЗначениеПоУмолчанию = 4;
	ОписаниеПараметра.Описание =
		НСтр("ru = 'Расчет амортизации в закрытии месяца может выполняться одновременно несколькими заданиями (потоками).
              |Увеличение количества заданий может уменьшить время расчета амортизации.
              |Количество заданий рекомендуется настраивать в зависимости от конфигурации сервера СУБД и серверов 1С:Предприятие.';
              |en = 'Depreciation upon month-end closing can be calculated simultaneously by several jobs (threads).
              |Increasing the number of jobs can reduce the depreciation calculation time.
              |Set the job number depending on the DBMS server configuration and 1C:Enterprise servers.'");
		
	#КонецОбласти
	
	#Область РазмерПорцииДанных
		
	ОписаниеПараметра = ОписаниеПараметров.Добавить();
	ОписаниеПараметра.Имя = "РазмерПорцииДанных";
	ОписаниеПараметра.Наименование = НСтр("ru = 'Количество пакетов обрабатываемых одновременно';
											|en = 'Number of packages processed simultaneously'");
	ОписаниеПараметра.ТипЗначения = Новый ОписаниеТипов("Число",,, Новый КвалификаторыЧисла(3, 0, ДопустимыйЗнак.Неотрицательный));
	ОписаниеПараметра.ДиапазонС = 1;
	ОписаниеПараметра.ЗначениеПоУмолчанию = 10;
	ОписаниеПараметра.Описание =
		НСтр("ru = 'В одном задании расчет амортизации может выполняться одновременно по нескольким пакетам.
              |Увеличение количества пакетов может уменьшить время выполнения операции, но увеличить потребление памяти.
              |Количество рекомендуется настраивать в зависимости от конфигурации сервера СУБД и серверов 1С:Предприятие.';
              |en = 'In one job, depreciation can be calculated simultaneously by several packages.
              |Increasing the number of packages can reduce the operation execution time but increase memory consumption.
              |Configure the number depending on the DBMS server configuration and 1C:Enterprise servers.'");
		
	#КонецОбласти
	
	Возврат ОписаниеПараметров;
	
КонецФункции

#КонецОбласти

#Область ВыполнениеОперации

// Выполняет расчет амортизации за указанный период.
//
// Параметры:
//  НачалоРасчета - Дата - Начало периода с которого требуется выполнить операцию
//  КонецРасчета - Дата - Конец периода по который требуется выполнить операцию
//  СписокОрганизаций - Массив из СправочникСсылка.Организации - Список организаций
//  ИдентификаторРасчета - УникальныйИдентификатор - идентификатор расчета
// 
// Возвращаемое значение:
//  Структура - результат расчета амортизации:
// 		* ЕстьОшибки - Булево - Истина, если были зарегистрированы ошибки во время выполнения
// 		* ТекстОшибки - Строка - Текст ошибки
// 		* КоличествоДанных - Число - Количество объектов, по которым рассчитана амортизация
//
Функция ВыполнитьОперацию(НачалоРасчета, КонецРасчета, СписокОрганизаций, ИдентификаторРасчета) Экспорт

	Результат = Новый Структура;
	Результат.Вставить("ЕстьОшибки", Ложь);
	Результат.Вставить("ТекстОшибки", "");
	Результат.Вставить("КоличествоДанных", 0);

	Если НЕ ВнеоборотныеАктивы.ИспользуетсяУправлениеВНА()
		ИЛИ НЕ ЗначениеЗаполнено(НачалоРасчета) 
		ИЛИ НачалоРасчета > КонецРасчета Тогда
			
		Возврат Результат;
	КонецЕсли; 
	
	НомерДоРасчета = РегистрыСведений.ЗаданияКРасчетуАмортизацииНМА.УвеличитьНомерЗадания();
	
	ТекущийМесяцРасчета = НачалоМесяца(НачалоРасчета);
	ИспользоватьВнеоборотныеАктивы2_4 = ПолучитьФункциональнуюОпцию("ИспользоватьВнеоборотныеАктивы2_4");
	НачалоРасчетаАмортизацииНМА2_4 = ВнеоборотныеАктивыЛокализация.ДатаНачалаУчетаВнеоборотныхАктивов2_4(); 
	
	// @skip-check query-in-loop
	// Проверка отключена т.к. операция должна выполняться "помесячно"
	Пока ТекущийМесяцРасчета <= КонецРасчета Цикл
		
		ЗакрытиеМесяцаСервер.ОчиститьПроблемыВыполненияРасчета(
			Перечисления.ОперацииЗакрытияМесяца.НачислениеАмортизацииНМА,
			СписокОрганизаций,
			ТекущийМесяцРасчета);
		
		Если ИспользоватьВнеоборотныеАктивы2_4 И ТекущийМесяцРасчета >= НачалоРасчетаАмортизацииНМА2_4 Тогда
			
			ДоступныеОрганизации = ЗакрытиеМесяцаСервер.ДоступныеДляРасчетаОрганизации(
				ТекущийМесяцРасчета, СписокОрганизаций);
			
			ЗаданияКРасчету = РегистрыСведений.ЗаданияКРасчетуАмортизацииНМА.ЗаданияКРасчету(
					ТекущийМесяцРасчета, КонецМесяца(ТекущийМесяцРасчета), НомерДоРасчета, ДоступныеОрганизации);
			
			ОчередьЗаданийКРасчету = СоздатьОчередьЗаданий(
				ТекущийМесяцРасчета, СписокОрганизаций, НомерДоРасчета, ЗаданияКРасчету.МенеджерВременныхТаблиц, "ЗаданияКРасчету");
		
			РезультатВыполнения = ВнеоборотныеАктивы.ВыполнитьОчередьЗаданий(ОчередьЗаданийКРасчету, МаксимальноеКоличествоЗаданий(), ИдентификаторРасчета);
			
			Результат.ЕстьОшибки = РезультатВыполнения.ЕстьОшибки;
			Результат.ТекстОшибки = РезультатВыполнения.ТекстОшибки;
			Результат.КоличествоДанных = Результат.КоличествоДанных + РезультатВыполнения.КоличествоДанных;
			
		Иначе
			
			РасчетАмортизацииНМАЛокализация.СоздатьДокументыАмортизацииНМА(НачалоРасчета, СписокОрганизаций, Результат.ЕстьОшибки);
			
			Если НЕ Результат.ЕстьОшибки Тогда
				
				РегистрыСведений.ЗаданияКРасчетуАмортизацииНМА.ЗафиксироватьРасчет(
					ТекущийМесяцРасчета, СписокОрганизаций, НомерДоРасчета);
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если Результат.ЕстьОшибки 
			И ЗначениеЗаполнено(Результат.ТекстОшибки) Тогда
			
			Для Каждого Организация Из СписокОрганизаций Цикл
				
				ВнеоборотныеАктивыСлужебный.ЗарегистрироватьПроблемуВыполненияРасчета(
					Перечисления.ОперацииЗакрытияМесяца.НачислениеАмортизацииНМА, 
					ТекущийМесяцРасчета,
					Организация,
					Результат.ТекстОшибки);
			
			КонецЦикла;
			
		КонецЕсли;
		
		ТекущийМесяцРасчета = КонецМесяца(ТекущийМесяцРасчета) + 1;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Используется для расчета амортизации НМА в фоне.
//
// Параметры:
//  ПараметрыРасчета - см. ПараметрыВыполнения
//  ИдентификаторФормы - УникальныйИдентификатор -
// 
// Возвращаемое значение:
//  см. ДлительныеОперации.ВыполнитьФункцию
// 
Функция ЗапуститьРасчетАмортизацииВФоне(ПараметрыРасчета, ИдентификаторФормы) Экспорт

	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияФункции(ИдентификаторФормы);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Расчет амортизации НМА';
															|en = 'Intangible asset amortization calculation'");
	
	ДлительнаяОперация = ДлительныеОперации.ВыполнитьФункцию(
		ПараметрыВыполнения, "Документы.АмортизацияНМА2_4.РассчитатьАмортизацию", ПараметрыРасчета);
	
	Возврат ДлительнаяОперация;

КонецФункции

// Формирует параметры необходимые для расчета амортизации
// 
// Возвращаемое значение:
//  Структура - Содержит поля:
//      * Период - Дата - Период в котором требуется рассчитать амортизацию (обязательный).
//      * СписокОрганизаций - Массив из СправочникСсылка.Организации -
//      * ЕстьОшибки - Булево - Признак наличия ошибок.
//      * ТекстОшибки - Строка - Текст исключения вызванного ошибкой.
//      * ВернутьПараметрыРасчета - Булево - Истина, если требуется вернуть, параметры расчета амортизации.
//      * АдресПараметровРасчета - Строка - Адрес временного хранилища.
//      * ЗаписатьДанные - Булево - Записать расчет амортизации.
//      * МенеджерВременныхТаблиц - МенеджерВременныхТаблиц - Менеджер временных таблиц.
//      * ИспользуемыеТаблицы - Строка - Таблицы, которые сформированы при расчете.
//      * КоличествоОбработанныхДанных - Число - Количество данных, обработанных при расчете, используется для замера.
//      * ПараметрыРасчетаПереопределены - Булево - Истина, если параметры расчета определяются в вызывающей процедуре.
//      * НомерПакета - Число - Номер пакета.
//      * Ссылка - ДокументСсылка.АмортизацияНМА2_4, ДокументСсылка.АмортизацияНМА2_4 - Ссылка на документ.
//      * Ответственный	- СправочникСсылка.Пользователи - Ответственный за документ (может быть не заполнен).
//      * Комментарий - Строка - Комментарий документа.
//      * НомерДоРасчета - Число - Номер задания до начала расчета.
//      * ПакетыАмортизации - ТаблицаЗначений - Содержит список организаций и номера пакетов (может быть не заполнен):
//             ** Организация - СправочникСсылка.Организации -
//             ** НомерПакета - Число -
//
Функция ПараметрыВыполнения() Экспорт

	ПараметрыРасчета = Новый Структура;
	ПараметрыРасчета.Вставить("Период", '000101010000');
	ПараметрыРасчета.Вставить("СписокОрганизаций", Новый Массив);
	ПараметрыРасчета.Вставить("ВернутьПараметрыРасчета", Ложь);
	ПараметрыРасчета.Вставить("АдресПараметровРасчета", Неопределено);
	ПараметрыРасчета.Вставить("ЗаписатьДанные", Истина);
	ПараметрыРасчета.Вставить("МенеджерВременныхТаблиц", Неопределено);
	ПараметрыРасчета.Вставить("ПараметрыРасчетаПереопределены", Ложь);
	ПараметрыРасчета.Вставить("НомерДоРасчета", Неопределено);
	
	// Возвращаемые параметры
	ПараметрыРасчета.Вставить("ЕстьОшибки", Ложь);
	ПараметрыРасчета.Вставить("ТекстОшибки", "");
	ПараметрыРасчета.Вставить("ИспользуемыеТаблицы", "НачисленнаяАмортизация");
	ПараметрыРасчета.Вставить("КоличествоОбработанныхДанных", 0);
	
	// Значения, используемые при расчете из формы документа.
	ПараметрыРасчета.Вставить("НомерПакета", Неопределено);
	ПараметрыРасчета.Вставить("Ссылка", Неопределено);
	ПараметрыРасчета.Вставить("Ответственный", Неопределено);
	ПараметрыРасчета.Вставить("Комментарий", Неопределено);
	
	// Описывает по каким пакетам нужно выполнить расчет.
	ПакетыАмортизации = Новый ТаблицаЗначений;
	ПакетыАмортизации.Колонки.Добавить("Организация", Новый ОписаниеТипов("СправочникСсылка.Организации"));
	ПакетыАмортизации.Колонки.Добавить("НомерПакета", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(10,0)));
	ПараметрыРасчета.Вставить("ПакетыАмортизации", ПакетыАмортизации);
	
	//@skip-check constructor-function-return-section
	Возврат ПараметрыРасчета;
	
КонецФункции

#КонецОбласти

#Область Прочее

// Определяет может ли амортизация начисляться с даты принятия к учету хотя бы у одной организации.
// 
// Параметры:
//  СписокОрганизаций - Массив из СправочникСсылка.Организации - Список организаций
//  Период - Дата - Период.
// 
// Возвращаемое значение:
//  Булево - Истина, если амортизация может начисляться с даты принятия к учету..
Функция АмортизацияМожетНачислятьсяСДатыПринятияКУчету(СписокОрганизаций, Период) Экспорт
	
	ТекстЗапроса = РасчетАмортизацииНМАЛокализация.ТекстЗапросаАмортизацияМожетНачислятьсяСДатыПринятияКУчету();
	
	Если ТекстЗапроса = Неопределено Тогда
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	Организации.ГоловнаяОрганизация КАК ГоловнаяОрганизация
		|ПОМЕСТИТЬ Организации
		|ИЗ
		|	Справочник.Организации КАК Организации
		|ГДЕ
		|	Организации.Ссылка В (&СписокОрганизаций)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	1 Приоритет,
		|	ЗНАЧЕНИЕ(Перечисление.ПорядокНачисленияАмортизации.СДатыПринятияКУчету) КАК ПорядокНачисленияАмортизации
		|ИЗ
		|	РегистрСведений.УчетнаяПолитикаФинансовогоУчета.СрезПоследних(
		|		&Период, 
		|		Организация В
		|			(ВЫБРАТЬ
		|				Организации.ГоловнаяОрганизация
		|			ИЗ
		|				Организации КАК Организации)) КАК УчетнаяПолитикаФинансовогоУчета
		|ГДЕ
		|	УчетнаяПолитикаФинансовогоУчета.ПорядокНачисленияАмортизацииНМА = ЗНАЧЕНИЕ(Перечисление.ПорядокНачисленияАмортизации.СДатыПринятияКУчету)
		|		ИЛИ УчетнаяПолитикаФинансовогоУчета.ПорядокНачисленияАмортизацииНМАРегл = ЗНАЧЕНИЕ(Перечисление.ПорядокНачисленияАмортизации.СДатыПринятияКУчету)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	2 Приоритет,
		|	ЗНАЧЕНИЕ(Перечисление.ПорядокНачисленияАмортизации.СоСледующегоМесяца) КАК ПорядокНачисленияАмортизации
		|ИЗ
		|	РегистрСведений.УчетнаяПолитикаФинансовогоУчета.СрезПоследних(
		|		&Период, 
		|		Организация В
		|			(ВЫБРАТЬ
		|				Организации.ГоловнаяОрганизация
		|			ИЗ
		|				Организации КАК Организации)) КАК УчетнаяПолитикаФинансовогоУчета
		|ГДЕ
		|	УчетнаяПолитикаФинансовогоУчета.ПорядокНачисленияАмортизацииНМА = ЗНАЧЕНИЕ(Перечисление.ПорядокНачисленияАмортизации.СоСледующегоМесяца)
		|		ИЛИ УчетнаяПолитикаФинансовогоУчета.ПорядокНачисленияАмортизацииНМАРегл = ЗНАЧЕНИЕ(Перечисление.ПорядокНачисленияАмортизации.СоСледующегоМесяца)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Приоритет";
	КонецЕсли;
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("СписокОрганизаций", СписокОрганизаций);
	Запрос.УстановитьПараметр("Период", Период);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.ПорядокНачисленияАмортизации = Перечисления.ПорядокНачисленияАмортизации.СДатыПринятияКУчету;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ВыполнениеОперации

// Рассчитать амортизацию по пакетам.
// 
// Параметры:
//  ПараметрыВыполнения - см. ПараметрыВыполнения
// 
// Возвращаемое значение:
//  Число - Рассчитать амортизацию по пакетам
Функция РассчитатьАмортизациюПоПакетам(ПараметрыВыполнения) Экспорт
	
	Если ПараметрыВыполнения.ПакетыАмортизации.Количество() = 0 Тогда
		Возврат 0;
	КонецЕсли;
	
	РезультатРасчета = Документы.АмортизацияНМА2_4.РассчитатьАмортизацию(ПараметрыВыполнения);
	
	Если НЕ РезультатРасчета.ЕстьОшибки Тогда
		
		РегистрыСведений.ЗаданияКРасчетуАмортизацииНМА.ЗафиксироватьРасчет(
			ПараметрыВыполнения.Период, 
			ПараметрыВыполнения.СписокОрганизаций, 
			ПараметрыВыполнения.НомерДоРасчета, 
			ПараметрыВыполнения.ПакетыАмортизации);
			
	КонецЕсли;
	
	Возврат РезультатРасчета.КоличествоОбработанныхДанных;
	
КонецФункции

// Устанавливает параметры запроса для расчета амортизации.
// 
// Параметры:
//  Запрос - Запрос -
//  ПараметрыРасчета - см. ПараметрыВыполнения
Процедура УстановитьПараметрыЗапросаДляРасчетаАмортизации(Запрос, ПараметрыРасчета = Неопределено) Экспорт

	Если ПараметрыРасчета <> Неопределено Тогда
		
		Запрос.УстановитьПараметр("НачалоМесяца", НачалоМесяца(ПараметрыРасчета.Период));
		Запрос.УстановитьПараметр("КонецМесяца",  КонецМесяца(ПараметрыРасчета.Период));
		Запрос.УстановитьПараметр("НачалоГода", НачалоГода(ПараметрыРасчета.Период));
		Запрос.УстановитьПараметр("НачалоПредыдущегоМесяца", НачалоМесяца(НачалоМесяца(ПараметрыРасчета.Период)-1));
		Запрос.УстановитьПараметр("НачалоСледующегоМесяца", НачалоМесяца(КонецМесяца(ПараметрыРасчета.Период)+1));
		Запрос.УстановитьПараметр("КонецПредыдущегоМесяца", КонецМесяца(НачалоМесяца(ПараметрыРасчета.Период)-1));
		Запрос.УстановитьПараметр("КонецПредыдущегоМесяцаГраница", Новый Граница(КонецМесяца(НачалоМесяца(ПараметрыРасчета.Период)-1), ВидГраницы.Включая));
		Запрос.УстановитьПараметр("НачалоПозапрошлогоМесяца", НачалоМесяца(ДобавитьМесяц(ПараметрыРасчета.Период, -2)));
		Запрос.УстановитьПараметр("КонецПозапрошлогоМесяца", КонецМесяца(ДобавитьМесяц(ПараметрыРасчета.Период, -2)));
		
		Если ПараметрыРасчета.Свойство("ПакетыАмортизации") Тогда
			Запрос.УстановитьПараметр("ПакетыАмортизации", ПараметрыРасчета.ПакетыАмортизации);
		КонецЕсли;

	КонецЕсли;
	
	Запрос.УстановитьПараметр("ВедетсяРегламентированныйУчетВНА", ВнеоборотныеАктивыСлужебный.ВедетсяРегламентированныйУчетВНА());
	Запрос.УстановитьПараметр("МинимальнаяОстаточнаяСтоимостьРегл", ВнеоборотныеАктивыСлужебный.МинимальнаяОстаточнаяСтоимостьРегл());
	Запрос.УстановитьПараметр("МинимальнаяОстаточнаяСтоимостьУпр", ВнеоборотныеАктивыСлужебный.МинимальнаяОстаточнаяСтоимостьУпр());
	Запрос.УстановитьПараметр("ВалютаУправленческогоУчета", Константы.ВалютаУправленческогоУчета.Получить());
	Запрос.УстановитьПараметр("ЭтоМеждународнаяВерсия", НЕ ПолучитьФункциональнуюОпцию("ЛокализацияРФ"));
	
	Запрос.УстановитьПараметр(
		"ДоначислятьКорректировкуОбесценения", 
		Перечисления.ВариантыПроводокПоОбесценениюВНА.ДоначислятьКорректировкуОбесценения);
	
	Запрос.УстановитьПараметр(
		"СторнироватьКорректировкуОбесценения", 
		Перечисления.ВариантыПроводокПоОбесценениюВНА.СторнироватьКорректировкуОбесценения);
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("ДокументСсылка.ПринятиеКУчетуНМА2_4"));
	Запрос.УстановитьПараметр("ТипПринятиеКУчету", МассивТипов);

	Запрос.УстановитьПараметр("ПустыеСпособыОтраженияРасходов", ВнеоборотныеАктивы.ПустыеСпособыОтраженияРасходов());
	
	РасчетАмортизацииНМАЛокализация.ДополнитьПараметрыЗапросаДляРасчетаАмортизации(Запрос, ПараметрыРасчета);
	
КонецПроцедуры

Функция СоздатьОчередьЗаданий(Период, СписокОрганизаций, НомерДоРасчета, МенеджерВременныхТаблиц, ИмяТаблицыОбъектов)

	ОчередьЗаданийКРасчету = ВнеоборотныеАктивы.ОчередьЗаданийКРасчету();
	
	КоличествоПакетовВОдномЗадании = КоличествоПакетовВОдномЗадании();
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЗаданияКРасчету.Организация КАК Организация,
	|	ЗаданияКРасчету.НомерПакета КАК НомерПакета
	|ИЗ
	|	ЗаданияКРасчету КАК ЗаданияКРасчету
	|
	|УПОРЯДОЧИТЬ ПО
	|	Организация,
	|	НомерПакета";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ДанныеЗадания = Неопределено;
		
		Если КоличествоПакетовВОдномЗадании > 1 Тогда
			Для Каждого СуществующиеДанныеЗадания Из ОчередьЗаданийКРасчету Цикл
				Если СуществующиеДанныеЗадания.ПараметрыЗадания.ПакетыАмортизации.Количество() < КоличествоПакетовВОдномЗадании
					И СуществующиеДанныеЗадания.ПараметрыЗадания.СписокОрганизаций.Найти(Выборка.Организация) <> Неопределено Тогда
					ДанныеЗадания = СуществующиеДанныеЗадания;
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		Если ДанныеЗадания = Неопределено Тогда
			
			ДанныеЗадания = ОчередьЗаданийКРасчету.Добавить();
			ДанныеЗадания.ПроцедураРасчета = "РасчетАмортизацииНМА.РассчитатьАмортизациюПоПакетам";
			
			ПараметрыВыполнения = ПараметрыВыполнения();
			ПараметрыВыполнения.Период = НачалоМесяца(Период);
			ПараметрыВыполнения.СписокОрганизаций = Новый Массив;
			ПараметрыВыполнения.НомерДоРасчета = НомерДоРасчета;
			
			ДанныеЗадания.ПараметрыЗадания = ПараметрыВыполнения;
			
		КонецЕсли;
		
		Если ДанныеЗадания.ПараметрыЗадания.СписокОрганизаций.Найти(Выборка.Организация) = Неопределено Тогда
			ДанныеЗадания.ПараметрыЗадания.СписокОрганизаций.Добавить(Выборка.Организация);
		КонецЕсли;
		
		ПараметрыПакета = ДанныеЗадания.ПараметрыЗадания.ПакетыАмортизации.Добавить();
		ПараметрыПакета.Организация = Выборка.Организация;
		ПараметрыПакета.НомерПакета = Выборка.НомерПакета;
		
	КонецЦикла;
	
	Для Каждого ДанныеЗадания Из ОчередьЗаданийКРасчету Цикл

		Если КоличествоПакетовВОдномЗадании = 1 Тогда
			
			ДанныеЗадания.НаименованиеФоновогоЗадания = 
				СтрШаблон(НСтр("ru = 'Расчет амортизации НМА (организация ""%1"", пакет %2)';
								|en = 'Intangible asset amortization calculation (the ""%1"" company, the %2 package)'"), 
						ДанныеЗадания.ПараметрыЗадания.ПакетыАмортизации[0].Организация, 
						Формат(ДанныеЗадания.ПараметрыЗадания.ПакетыАмортизации[0].НомерПакета, "ЧЦ=4; ЧВН=; ЧГ=;"));
				
		Иначе
			 
			ДанныеЗадания.НаименованиеФоновогоЗадания = 
				СтрШаблон(НСтр("ru = 'Расчет амортизации НМА (организация ""%1"", пакеты %2-%3)';
								|en = 'Intangible asset amortization calculation (the ""%1"" company, the %2-%3 packages)'"),
					ДанныеЗадания.ПараметрыЗадания.ПакетыАмортизации[0].Организация,  
					Формат(ДанныеЗадания.ПараметрыЗадания.ПакетыАмортизации[0].НомерПакета, "ЧЦ=4; ЧВН=; ЧГ=;"), 
					Формат(ДанныеЗадания.ПараметрыЗадания.ПакетыАмортизации[ДанныеЗадания.ПараметрыЗадания.ПакетыАмортизации.Количество() -1].НомерПакета, "ЧЦ=4; ЧВН=; ЧГ=;"));
				 
		КонецЕсли;
	
	КонецЦикла;
	
	Возврат ОчередьЗаданийКРасчету;
	
КонецФункции

#КонецОбласти

#Область Прочее

Процедура СформироватьЗадания(Документ, ДанныеТаблиц) Экспорт
	
	СписокТаблиц = Новый Массив;
	СписокТаблиц.Добавить("ВыработкаНМА");
	СписокТаблиц.Добавить("МестоУчетаНМА");
	СписокТаблиц.Добавить("ПараметрыАмортизацииНМАБУ");
	СписокТаблиц.Добавить("ПараметрыАмортизацииНМАУУ");
	СписокТаблиц.Добавить("ПервоначальныеСведенияНМА");
	СписокТаблиц.Добавить("ПорядокУчетаНМА");
	СписокТаблиц.Добавить("ПорядокУчетаНМАБУ");
	СписокТаблиц.Добавить("ПорядокУчетаНМАУУ");
	СписокТаблиц.Добавить("СтоимостьНМА");
	
	СписокДопПолей = "НематериальныйАктив,ОтражатьВРеглУчете,ОтражатьВУпрУчете";
	ТекстОбъединенияДанных = ВнеоборотныеАктивы.СформироватьТекстОбъединенияДанныхДляФормированияЗадания(СписокТаблиц, ДанныеТаблиц, СписокДопПолей);
	
	// При корректировке стоимости и амортизации нельзя до формирования движений узнать есть ли отклонения.
	// Поэтому задание формируется всегда.
	ЗарегистрироватьДокумент = 
		Документ <> Неопределено
		И ТипЗнч(Документ.Ссылка) = Тип("ДокументСсылка.КорректировкаСтоимостиИАмортизацииНМА");
		
	Если ТекстОбъединенияДанных = "" И НЕ ЗарегистрироватьДокумент Тогда
		Возврат;
	КонецЕсли;
		
	Если ЗарегистрироватьДокумент Тогда
		
		СписокЗапросовОбъединение = Новый Массив;
		
		Если ТекстОбъединенияДанных <> "" Тогда
			СписокЗапросовОбъединение.Добавить(ТекстОбъединенияДанных);
		КонецЕсли; 
			
		ТекстЗапроса =
		"ВЫБРАТЬ
		|	ИзмененныеДанные.Дата КАК Период,
		|	ИзмененныеДанные.Организация КАК Организация,
		|	ИзмененныеДанные.Ссылка КАК Документ,
		|	"""" КАК ИмяТаблицы,
		|	ИзмененныеДанные.НематериальныйАктив КАК НематериальныйАктив,
		|	ИзмененныеДанные.ОтражатьВРеглУчете КАК ОтражатьВРеглУчете,
		|	ИзмененныеДанные.ОтражатьВУпрУчете КАК ОтражатьВУпрУчете
		|ИЗ
		|	РегистрСведений.ДокументыПоНМА КАК ИзмененныеДанные
		|ГДЕ
		|	ИзмененныеДанные.Ссылка = &Ссылка";
		
		СписокЗапросовОбъединение.Добавить(ТекстЗапроса);
		
		ТекстОбъединенияДанных = СтрСоединить(СписокЗапросовОбъединение, ОбщегоНазначенияУТ.РазделительЗапросовВОбъединении());
		
	КонецЕсли; 
	
	Если ТекстОбъединенияДанных = "" Тогда
		Возврат;
	КонецЕсли;
	
	ТекстЗапроса = ВнеоборотныеАктивыЛокализация.ТекстЗапросаДляФормированияЗаданийКРасчетуАмортизацииНМА(
						ДанныеТаблиц, ТекстОбъединенияДанных);
	
	Если ТекстЗапроса = Неопределено Тогда
		
		СписокЗапросов = Новый Массив;
		
		#Область ИзмененныеДанные
		ТекстЗапроса =
		"ВЫБРАТЬ
		|	ИзмененныеДанные.ИмяТаблицы                      КАК ИмяТаблицы,
		|	ИзмененныеДанные.Организация                     КАК Организация,
		|	ВЫРАЗИТЬ(ИзмененныеДанные.Организация КАК Справочник.Организации).ГоловнаяОрганизация КАК ГоловнаяОрганизация,
		|	ИзмененныеДанные.НематериальныйАктив             КАК НематериальныйАктив,
		|	ИзмененныеДанные.Документ                        КАК Документ,
		|	МАКСИМУМ(ИзмененныеДанные.ОтражатьВРеглУчете)    КАК ОтражатьВРеглУчете,
		|	МАКСИМУМ(ИзмененныеДанные.ОтражатьВУпрУчете)     КАК ОтражатьВУпрУчете,
		|	МИНИМУМ(ИзмененныеДанные.Период)                 КАК Период
		|
		|ПОМЕСТИТЬ ВсеИзмененныеДанные
		|ИЗ
		|	ТекстОбъединенияДанных_Переопределямый КАК ИзмененныеДанные
		|
		|СГРУППИРОВАТЬ ПО
		|	ИзмененныеДанные.ИмяТаблицы,
		|	ИзмененныеДанные.Организация,
		|	ВЫРАЗИТЬ(ИзмененныеДанные.Организация КАК Справочник.Организации).ГоловнаяОрганизация,
		|	ИзмененныеДанные.НематериальныйАктив,
		|	ИзмененныеДанные.Документ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	УчетнаяПолитикаФинансовогоУчетаПоследнее.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
		|	УчетнаяПолитикаФинансовогоУчетаПоследнее.Период КАК Период,
		|	УчетнаяПолитикаФинансовогоУчета.ПорядокНачисленияАмортизацииНМА КАК ПорядокНачисленияАмортизации,
		|	УчетнаяПолитикаФинансовогоУчета.ПорядокНачисленияАмортизацииНМАРегл КАК ПорядокНачисленияАмортизацииРегл
		|ПОМЕСТИТЬ УчетнаяПолитикаФинансовогоУчета
		|ИЗ
		|	(ВЫБРАТЬ
		|		ВсеИзмененныеДанные.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
		|		ВсеИзмененныеДанные.Период КАК Период,
		|		МАКСИМУМ(УчетнаяПолитикаФинансовогоУчетаПоследнее.Период) КАК ПериодРегистра
		|	ИЗ
		|		ВсеИзмененныеДанные КАК ВсеИзмененныеДанные
		|
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.УчетнаяПолитикаФинансовогоУчета КАК УчетнаяПолитикаФинансовогоУчетаПоследнее
		|			ПО УчетнаяПолитикаФинансовогоУчетаПоследнее.Организация = ВсеИзмененныеДанные.ГоловнаяОрганизация
		|				И УчетнаяПолитикаФинансовогоУчетаПоследнее.Период <= ВсеИзмененныеДанные.Период
		|
		|	СГРУППИРОВАТЬ ПО
		|		ВсеИзмененныеДанные.ГоловнаяОрганизация,
		|		ВсеИзмененныеДанные.Период
		|	
		|	) КАК УчетнаяПолитикаФинансовогоУчетаПоследнее
		|	
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.УчетнаяПолитикаФинансовогоУчета КАК УчетнаяПолитикаФинансовогоУчета
		|		ПО УчетнаяПолитикаФинансовогоУчета.Организация = УчетнаяПолитикаФинансовогоУчетаПоследнее.ГоловнаяОрганизация
		|			И УчетнаяПолитикаФинансовогоУчета.Период = УчетнаяПолитикаФинансовогоУчетаПоследнее.ПериодРегистра
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВсеИзмененныеДанные.Организация                   КАК Организация,
		|	ВсеИзмененныеДанные.НематериальныйАктив           КАК НематериальныйАктив,
		|	ВсеИзмененныеДанные.Документ                      КАК Документ,
		|	МАКСИМУМ(ВсеИзмененныеДанные.ОтражатьВРеглУчете)  КАК ОтражатьВРеглУчете,
		|	МАКСИМУМ(ВсеИзмененныеДанные.ОтражатьВУпрУчете)   КАК ОтражатьВУпрУчете,
		|
		|	МАКСИМУМ(ЕСТЬNULL(УчетнаяПолитикаФинансовогоУчета.ПорядокНачисленияАмортизации, ЗНАЧЕНИЕ(Перечисление.ПорядокНачисленияАмортизации.СДатыПринятияКУчету))) КАК ПорядокНачисленияАмортизацииУУ,
		|	МАКСИМУМ(ЕСТЬNULL(УчетнаяПолитикаФинансовогоУчета.ПорядокНачисленияАмортизацииРегл, ЗНАЧЕНИЕ(Перечисление.ПорядокНачисленияАмортизации.СДатыПринятияКУчету))) КАК ПорядокНачисленияАмортизацииБУ,
		|
		|	МИНИМУМ(ВЫБОР 
		|				КОГДА ТИПЗНАЧЕНИЯ(ВсеИзмененныеДанные.Документ) = ТИП(Документ.ВводОстатковВнеоборотныхАктивов2_4)
		|						ИЛИ &ДвиженияЗаписываютсяПриРасчетеСтоимостиВНА
		|						ИЛИ &ДвиженияЗаписываютсяПриАктуализацияДвиженийПоВНА
		|						ИЛИ &ДвиженияЗаписываютсяПриОтложенномФормированииДвижений
		|
		|					ТОГДА ДОБАВИТЬКДАТЕ(НАЧАЛОПЕРИОДА(ВсеИзмененныеДанные.Период, МЕСЯЦ), МЕСЯЦ, 1)
		| 
		|				КОГДА ВсеИзмененныеДанные.ИмяТаблицы = ""ВыработкаНМА""
		|						ИЛИ ЕСТЬNULL(УчетнаяПолитикаФинансовогоУчета.ПорядокНачисленияАмортизацииРегл, ЗНАЧЕНИЕ(Перечисление.ПорядокНачисленияАмортизации.СДатыПринятияКУчету)) = ЗНАЧЕНИЕ(Перечисление.ПорядокНачисленияАмортизации.СДатыПринятияКУчету)
		|
		|					ТОГДА НАЧАЛОПЕРИОДА(ВсеИзмененныеДанные.Период, МЕСЯЦ)
		|
		|				ИНАЧЕ ДОБАВИТЬКДАТЕ(НАЧАЛОПЕРИОДА(ВсеИзмененныеДанные.Период, МЕСЯЦ), МЕСЯЦ, 1)
		| 
		|			КОНЕЦ) КАК ПериодБУ,
		|
		|	МИНИМУМ(ВЫБОР 
		|				КОГДА ТИПЗНАЧЕНИЯ(ВсеИзмененныеДанные.Документ) = ТИП(Документ.ВводОстатковВнеоборотныхАктивов2_4)
		|						ИЛИ &ДвиженияЗаписываютсяПриРасчетеСтоимостиВНА
		|						ИЛИ &ДвиженияЗаписываютсяПриАктуализацияДвиженийПоВНА
		|						ИЛИ &ДвиженияЗаписываютсяПриОтложенномФормированииДвижений
		|
		|					ТОГДА ДОБАВИТЬКДАТЕ(НАЧАЛОПЕРИОДА(ВсеИзмененныеДанные.Период, МЕСЯЦ), МЕСЯЦ, 1)
		| 
		|				КОГДА ВсеИзмененныеДанные.ИмяТаблицы = ""ВыработкаНМА""
		|						ИЛИ ЕСТЬNULL(УчетнаяПолитикаФинансовогоУчета.ПорядокНачисленияАмортизации, ЗНАЧЕНИЕ(Перечисление.ПорядокНачисленияАмортизации.СДатыПринятияКУчету)) = ЗНАЧЕНИЕ(Перечисление.ПорядокНачисленияАмортизации.СДатыПринятияКУчету)
		|
		|					ТОГДА НАЧАЛОПЕРИОДА(ВсеИзмененныеДанные.Период, МЕСЯЦ)
		|
		|				ИНАЧЕ ДОБАВИТЬКДАТЕ(НАЧАЛОПЕРИОДА(ВсеИзмененныеДанные.Период, МЕСЯЦ), МЕСЯЦ, 1)
		| 
		|			КОНЕЦ) КАК ПериодУУ
		|
		|ПОМЕСТИТЬ ИзмененныеДанные
		|
		|ИЗ
		|	ВсеИзмененныеДанные КАК ВсеИзмененныеДанные
		|
		|		ЛЕВОЕ СОЕДИНЕНИЕ УчетнаяПолитикаФинансовогоУчета КАК УчетнаяПолитикаФинансовогоУчета
		|		ПО УчетнаяПолитикаФинансовогоУчета.ГоловнаяОрганизация = ВсеИзмененныеДанные.ГоловнаяОрганизация
		|			И УчетнаяПолитикаФинансовогоУчета.Период = ВсеИзмененныеДанные.Период
		|
		|СГРУППИРОВАТЬ ПО
		|	ВсеИзмененныеДанные.Организация,
		|	ВсеИзмененныеДанные.НематериальныйАктив,
		|	ВсеИзмененныеДанные.Документ
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Организация,
		|	НематериальныйАктив";
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ТекстОбъединенияДанных_Переопределямый", "(" + ТекстОбъединенияДанных + ")");
		СписокЗапросов.Добавить(ТекстЗапроса);
		#КонецОбласти
				
		#Область ФормированиеЗаданий
		ТекстЗапроса =
		"ВЫБРАТЬ
		|	ИзмененныеДанные.Организация,
		|	ИзмененныеДанные.Документ,
		|	ЕСТЬNULL(ПакетыАмортизацииНМА.НомерПакета, 0) КАК НомерПакета,
		|
		|	МИНИМУМ(ВЫБОР 
		|				КОГДА ИзмененныеДанные.ПериодБУ <= ИзмененныеДанные.ПериодУУ
		|						ИЛИ ИзмененныеДанные.ПериодУУ ЕСТЬ NULL
		|					ТОГДА ИзмененныеДанные.ПериодБУ
		|				ИНАЧЕ ИзмененныеДанные.ПериодУУ
		|			КОНЕЦ) КАК Месяц
		|ИЗ
		|	ИзмененныеДанные КАК ИзмененныеДанные
		|
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПакетыАмортизацииНМА КАК ПакетыАмортизацииНМА
		|		ПО (ПакетыАмортизацииНМА.Организация = ИзмененныеДанные.Организация)
		|			И (ПакетыАмортизацииНМА.НематериальныйАктив = ИзмененныеДанные.НематериальныйАктив)
		|
		|СГРУППИРОВАТЬ ПО
		|	ИзмененныеДанные.Организация,
		|	ИзмененныеДанные.Документ,
		|	ЕСТЬNULL(ПакетыАмортизацииНМА.НомерПакета, 0)";
		
		СписокЗапросов.Добавить(ТекстЗапроса);
		
		Если ДанныеТаблиц.МенеджерВременныхТаблиц.Таблицы.Найти("ПорядокУчетаНМАБУ_НачислятьАмортизацию") <> Неопределено Тогда
			ТекстЗапроса = "УНИЧТОЖИТЬ ПорядокУчетаНМАБУ_НачислятьАмортизацию";
			СписокЗапросов.Добавить(ТекстЗапроса);
		КонецЕсли;
	
		Если ДанныеТаблиц.МенеджерВременныхТаблиц.Таблицы.Найти("ПорядокУчетаНМАУУ_НачислятьАмортизацию") <> Неопределено Тогда
			ТекстЗапроса = "УНИЧТОЖИТЬ ПорядокУчетаНМАУУ_НачислятьАмортизацию";
			СписокЗапросов.Добавить(ТекстЗапроса);
		КонецЕсли;
		
		#КонецОбласти
		
		ТекстЗапроса = СтрСоединить(СписокЗапросов, ОбщегоНазначения.РазделительПакетаЗапросов());
	
	КонецЕсли; 

	ИспользуемыеВременныеТаблицы = ОбщегоНазначенияУТ.СписокВременныхТаблиц(ДанныеТаблиц.МенеджерВременныхТаблиц);
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.МенеджерВременныхТаблиц = ДанныеТаблиц.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ДатаНачалаУчета24", ВнеоборотныеАктивыЛокализация.ДатаНачалаУчетаВнеоборотныхАктивов2_4());
	Запрос.УстановитьПараметр("Ссылка", Документ.Ссылка);
	
	Запрос.УстановитьПараметр(
		"ДвиженияЗаписываютсяПриРасчетеСтоимостиВНА", 
		РасчетСтоимостиВНА.ДвиженияЗаписываютсяПриВыполненииОперации(Документ));
	
	Запрос.УстановитьПараметр(
		"ДвиженияЗаписываютсяПриОтложенномФормированииДвижений", 
		ОтложенноеФормированиеДвиженийВНА.ДвиженияЗаписываютсяПриВыполненииОперации(Документ));
	
	Запрос.УстановитьПараметр(
		"ДвиженияЗаписываютсяПриАктуализацияДвиженийПоВНА", 
		РасчетСтоимостиВНА.ДвиженияЗаписываютсяПриАктуализацияДвиженийПоВНА(Документ));

	УстановитьПривилегированныйРежим(Истина);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ОбщегоНазначенияУТ.УничтожитьВременныеТаблицы(ДанныеТаблиц.МенеджерВременныхТаблиц,, ИспользуемыеВременныеТаблицы);
	
	РегистрыСведений.ЗаданияКРасчетуАмортизацииНМА.СоздатьЗаписиРегистраПоДаннымВыборки(РезультатЗапроса.Выбрать());
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

Функция МаксимальноеКоличествоЗаданий()

	ЗначенияПараметров = Константы.НастройкиЗакрытияМесяца.СоздатьМенеджерЗначения().УстановленныеЗначенияПараметровОперации(
  							Перечисления.ОперацииЗакрытияМесяца.НачислениеАмортизацииНМА);
							
	Возврат ЗначенияПараметров.МаксимальноеКоличествоЗаданий;

КонецФункции

Функция КоличествоПакетовВОдномЗадании()

	ЗначенияПараметров = Константы.НастройкиЗакрытияМесяца.СоздатьМенеджерЗначения().УстановленныеЗначенияПараметровОперации(
  							Перечисления.ОперацииЗакрытияМесяца.НачислениеАмортизацииОС);
							
	Возврат ЗначенияПараметров.РазмерПорцииДанных;

КонецФункции

#КонецОбласти

#КонецОбласти
