

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	
	
КонецПроцедуры

// Добавляет команду создания документа "Процесс подготовки бюджетов".
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
// Возвращаемое значение:
//	ТаблицаЗначений, Неопределено - сформированные команды для вывода в подменю.
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	Если ПравоДоступа("Добавление", Метаданные.Документы.ПроцессПодготовкиБюджетов) Тогда
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.ПроцессПодготовкиБюджетов.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначенияУТ.ПредставлениеОбъекта(Метаданные.Документы.ПроцессПодготовкиБюджетов);
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		
	

		Возврат КомандаСоздатьНаОсновании;
	КонецЕсли;

	Возврат Неопределено;
КонецФункции

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//   Параметры - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.Параметры
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	Возврат; //В дальнейшем будет добавлен код команд
	
КонецПроцедуры

Функция НайтиСтроки(СтрокиДерева, СтруктураПоиска) Экспорт
	
	Для Каждого Строка Из СтрокиДерева Цикл
		Подходит = Истина;
		Для Каждого КлючИЗначение Из СтруктураПоиска Цикл
			Если Строка[КлючИЗначение.Ключ] <> КлючИЗначение.Значение Тогда
				Подходит = Ложь;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если Подходит Тогда
			Возврат Строка.ПолучитьИдентификатор();
		КонецЕсли;
		
		Результат = НайтиСтроки(Строка.ПолучитьЭлементы(), СтруктураПоиска);
		Если Результат <> Неопределено Тогда
			Возврат Результат;
		КонецЕсли;
	КонецЦикла;
	
КонецФункции


// Заполняет статусы задач.
// 
// Параметры:
// 	ДокументОбъект - ДокументОбъект.ПроцессПодготовкиБюджетов - Документ процесса подготовки бюджета.
// 	ДеревоШаговБюджетногоПроцесса - См. ИерархияЭтаповПроцессаПоДокументу
// 	
Процедура ЗаполнитьСтатусыЗадачДерева(ДокументОбъект, ДеревоШаговБюджетногоПроцесса) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	БюджетнаяЗадача.ЭтапПодготовкиБюджетов,
		|	БюджетнаяЗадача.ЭтапПодготовкиБюджетовОснование,
		|	БюджетнаяЗадача.Выполнена,
		|	БюджетнаяЗадача.ПометкаУдаления,
		|	БюджетнаяЗадача.Период
		|ПОМЕСТИТЬ ВременнаяТаблица
		|ИЗ
		|	Задача.БюджетнаяЗадача КАК БюджетнаяЗадача
		|ГДЕ
		|	БюджетнаяЗадача.ПроцессПодготовкиБюджетов = &ПроцессПодготовкиБюджетов
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблица.ЭтапПодготовкиБюджетов,
		|	ВременнаяТаблица.ЭтапПодготовкиБюджетовОснование,
		|	ВременнаяТаблица.Выполнена,
		|	ВременнаяТаблица.Период
		|ИЗ
		|	ВременнаяТаблица КАК ВременнаяТаблица
		|ГДЕ
		|	НЕ ВременнаяТаблица.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("ПроцессПодготовкиБюджетов", ДокументОбъект.Ссылка);
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		СтруктураПоиска = Новый Структура("ЭтапПодготовкиБюджетов, ЭтапПодготовкиБюджетовОснование, Период", 
												ВыборкаДетальныеЗаписи.ЭтапПодготовкиБюджетов, 
												ВыборкаДетальныеЗаписи.ЭтапПодготовкиБюджетовОснование,
												ВыборкаДетальныеЗаписи.Период);
		
		Если ТипЗнч(ДеревоШаговБюджетногоПроцесса) = Тип("ДанныеФормыДерево") Тогда
			НайденнаяСтрока = НайтиСтроки(ДеревоШаговБюджетногоПроцесса.ПолучитьЭлементы(), СтруктураПоиска);
			СтрокаОбработки = ДеревоШаговБюджетногоПроцесса.НайтиПоИдентификатору(НайденнаяСтрока);
		Иначе
			НайденнаяСтрока = ДеревоШаговБюджетногоПроцесса.Строки.НайтиСтроки(СтруктураПоиска)[0];
		КонецЕсли;
		
		Если ВыборкаДетальныеЗаписи.Выполнена Тогда
			СтрокаОбработки.ИндексСтатуса = 2;
		Иначе
			СтрокаОбработки.ИндексСтатуса = 1;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ВДеревеЭтаповВсеЗадачиВыполнены(ДеревоШаговБюджетногоПроцесса) Экспорт
	
	Если ТипЗнч(ДеревоШаговБюджетногоПроцесса) = Тип("ДанныеФормыДерево") Тогда
		ЭлементыДерева = ДеревоШаговБюджетногоПроцесса.ПолучитьЭлементы();
		Возврат НайтиСтроки(ЭлементыДерева, Новый Структура("НеВыполняется, ИндексСтатуса", Ложь, 2)) <> Неопределено
				И НайтиСтроки(ЭлементыДерева, Новый Структура("НеВыполняется, ИндексСтатуса", Ложь, 0)) = Неопределено
				И НайтиСтроки(ЭлементыДерева, Новый Структура("НеВыполняется, ИндексСтатуса", Ложь, 1)) = Неопределено
	Иначе
		ЭлементыДерева = ДеревоШаговБюджетногоПроцесса.Строки;
		Возврат ЭлементыДерева.НайтиСтроки(Новый Структура("НеВыполняется, ИндексСтатуса", Ложь, 2), Истина).Количество()
			И ЭлементыДерева.НайтиСтроки(Новый Структура("НеВыполняется, ИндексСтатуса", Ложь, 0), Истина).Количество() = 0
			И ЭлементыДерева.НайтиСтроки(Новый Структура("НеВыполняется, ИндексСтатуса", Ложь, 1), Истина).Количество() = 0
	КонецЕсли;
		
КонецФункции

Функция ОбойтиЗаполнитьДатыГруппДерева(НовыеСтроки, СтрокиДерева, НачалоПериода, КонецПериода, 
										ПериодичностьРодителя, НастройкиРасчета)
	
	Для Каждого СтрокаДерева Из СтрокиДерева Цикл
		ПериодЗадачи = НачалоПериода;
		Пока ПериодЗадачи < КонецПериода Цикл
			Если СтрокаДерева.ЭтоГруппа Тогда
				НоваяСтрока = НовыеСтроки.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаДерева);
				НоваяСтрока.Наименование = СтрокаДерева.ЭтапПодготовкиБюджетовНаименование;
				Если Не ЗначениеЗаполнено(НоваяСтрока.Наименование) Тогда
					НоваяСтрока.Наименование = Строка(СтрокаДерева.ЭтапПодготовкиБюджетов);
				КонецЕсли;
				НоваяСтрока.Период = ПериодЗадачи;
				Если СтрокаДерева.Периодичность <> ПериодичностьРодителя Тогда
					НоваяСтрока.ПредставлениеПериода = БюджетированиеКлиентСервер.ПредставлениеПериодаПоДате(ПериодЗадачи, СтрокаДерева.Периодичность);
				КонецЕсли;
				НоваяСтрока.ИндексКартинки = 1;
				НоваяСтрока.ИндексСтатуса = -1;
				КонецПериодаЗадачи = БюджетированиеКлиентСервер.ДатаКонцаПериода(ПериодЗадачи, СтрокаДерева.Периодичность);
				ОбойтиЗаполнитьДатыГруппДерева(НоваяСтрока.Строки, СтрокаДерева.Строки, ПериодЗадачи, КонецПериодаЗадачи, СтрокаДерева.Периодичность, НастройкиРасчета);
			Иначе
				НоваяСтрока = НовыеСтроки.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаДерева);
				НоваяСтрока.Наименование = СтрокаДерева.ЭтапПодготовкиБюджетовНаименование;
				НоваяСтрока.Период = ПериодЗадачи;
				Если Не ЗначениеЗаполнено(НоваяСтрока.Родитель) Тогда
					НоваяСтрока.ПредставлениеПериода = БюджетированиеКлиентСервер.ПредставлениеПериодаПоДате(ПериодЗадачи, СтрокаДерева.Периодичность);
				Иначе
					НоваяСтрока.ПредставлениеПериода = "";
				КонецЕсли;
				
				СтрокиНастроек = НастройкиРасчета.НайтиСтроки(Новый Структура("Период, ЭтапПодготовкиБюджетов, ЭтапПодготовкиБюджетовОснование", 
												НоваяСтрока.Период, НоваяСтрока.ЭтапПодготовкиБюджетов, НоваяСтрока.ЭтапПодготовкиБюджетовОснование));
				ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокиНастроек[0], "Ответственный, Длительность, ТипДлительности, НеВыполняется, ВыполнятьАвтоматически");
				
			КонецЕсли;
			ПериодЗадачи = БюджетированиеКлиентСервер.ДобавитьИнтервал(ПериодЗадачи, СтрокаДерева.Периодичность, 1);
		КонецЦикла;
	КонецЦикла;
	
КонецФункции

Процедура СкопироватьДеревоПовторяемыхШагов(СтрокиПриемник, СтрокиИсточник, ЭтапПодготовкиБюджетов)
	
	Для Каждого СтрокаИсточник Из СтрокиИсточник Цикл
		
		Если СтрокаИсточник.ЭтапПодготовкиБюджетовОснованиеДействие = Перечисления.ТипыДействийЭтаповПодготовкиБюджетов.ПовторГруппыЭтапов Тогда
			Продолжить;
		КонецЕсли;
		
		Приемник = СтрокиПриемник.Добавить();
		ЗаполнитьЗначенияСвойств(Приемник, СтрокаИсточник);
		Приемник.ЭтапПодготовкиБюджетов = ЭтапПодготовкиБюджетов;
		Если СтрокаИсточник.ЭтоГруппа Тогда
			Приемник.ЭтапПодготовкиБюджетовНаименование = Строка(СтрокаИсточник.ЭтапПодготовкиБюджетовОснование);
		Иначе
			Приемник.ЭтапПодготовкиБюджетовНаименование = СтрокаИсточник.ЭтапПодготовкиБюджетовОснованиеНаименование;
			Приемник.ЭтапПодготовкиБюджетовНастройкаДействия = СтрокаИсточник.ЭтапПодготовкиБюджетовОснованиеНастройкаДействия;
			Приемник.ЭтапПодготовкиБюджетовДействие = СтрокаИсточник.ЭтапПодготовкиБюджетовОснованиеДействие;
		КонецЕсли;
		
		СкопироватьДеревоПовторяемыхШагов(Приемник.Строки, СтрокаИсточник.Строки, ЭтапПодготовкиБюджетов);
		
	КонецЦикла;
	
КонецПроцедуры


// Описание
// 
// Параметры:
// 	НастройкиИерархии - ТаблицаЗначений - Таблица, выгруженная из табличной части НастройкиИерархии.
// Возвращаемое значение:
// 	ДеревоЗначений - Описание:
// * ЭтапПодготовкиБюджетовОснование - СправочникСсылка.ЭтапыПодготовкиБюджетов - этап подготовки бюджетов.
Функция ИерархияЭтаповПроцессаПоДокументу(Знач НастройкиИерархии) Экспорт
	
	МассивШагов = НастройкиИерархии.ВыгрузитьКолонку("ЭтапПодготовкиБюджетов");
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивШагов, НастройкиИерархии.ВыгрузитьКолонку("ЭтапПодготовкиБюджетовОснование"));
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(МассивШагов, "ЭтоГруппа, Родитель, Срок, ТипСрока, УсловиеЗапуска");
	
	МассивШагов = Новый Массив;
	МассивИерархия = Новый Массив;
	МассивШаговПовторяемые = Новый Массив;
	МассивИерархияПовторяемые = Новый Массив;
	
	НастройкиИерархии.Колонки.Добавить("ЭтоГруппа");
	НастройкиИерархии.Колонки.Добавить("Срок");
	НастройкиИерархии.Колонки.Добавить("ТипСрока");
	НастройкиИерархии.Колонки.Добавить("УсловиеЗапуска");
	Для Каждого СтрокаТаблицы Из НастройкиИерархии Цикл
		Если Не ЗначениеЗаполнено(СтрокаТаблицы.ЭтапПодготовкиБюджетовОснование) Тогда
			ЗначенияРеквизитовОбъекта = ЗначенияРеквизитов[СтрокаТаблицы.ЭтапПодготовкиБюджетов]; 
			СтрокаТаблицы.ЭтоГруппа = ЗначенияРеквизитовОбъекта.ЭтоГруппа;
			Родитель = ЗначенияРеквизитовОбъекта.Родитель;
			Если ЗначениеЗаполнено(Родитель) Тогда
				ЗначенияРеквизитовРодителя = ЗначенияРеквизитов[Родитель];
				Если ЗначенияРеквизитовРодителя = Неопределено Тогда
					ЗначенияРеквизитовРодителя = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Родитель, "Срок, ТипСрока, УсловиеЗапуска");	
				КонецЕсли;
				СтрокаТаблицы.Срок = ЗначенияРеквизитовРодителя.Срок;
				СтрокаТаблицы.ТипСрока = ЗначенияРеквизитовРодителя.ТипСрока;
				СтрокаТаблицы.УсловиеЗапуска = ЗначенияРеквизитовРодителя.УсловиеЗапуска;
			КонецЕсли;
			МассивИерархия.Добавить(СтрокаТаблицы);
		Иначе
			ЗначенияРеквизитовОбъекта = ЗначенияРеквизитов[СтрокаТаблицы.ЭтапПодготовкиБюджетовОснование];
			СтрокаТаблицы.ЭтоГруппа = ЗначенияРеквизитовОбъекта.ЭтоГруппа;
			Родитель = ЗначенияРеквизитовОбъекта.Родитель;
			Если ЗначениеЗаполнено(Родитель) Тогда
				ЗначенияРеквизитовРодителя = ЗначенияРеквизитов[Родитель];
				Если ЗначенияРеквизитовРодителя = Неопределено Тогда
					ЗначенияРеквизитовРодителя = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Родитель, "Срок, ТипСрока, УсловиеЗапуска");	
				КонецЕсли;
				СтрокаТаблицы.Срок = ЗначенияРеквизитовРодителя.Срок;
				СтрокаТаблицы.ТипСрока = ЗначенияРеквизитовРодителя.ТипСрока;
				СтрокаТаблицы.УсловиеЗапуска = ЗначенияРеквизитовРодителя.УсловиеЗапуска;

			КонецЕсли;
			МассивИерархияПовторяемые.Добавить(СтрокаТаблицы);
		КонецЕсли;
		Если Не СтрокаТаблицы.ЭтоГруппа Тогда
			Если Не ЗначениеЗаполнено(СтрокаТаблицы.ЭтапПодготовкиБюджетовОснование) Тогда
				МассивШагов.Добавить(СтрокаТаблицы);
			Иначе
				МассивШаговПовторяемые.Добавить(СтрокаТаблицы);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	ШагиБезПовторяемых = НастройкиИерархии.Скопировать(МассивШагов);
	ИерархияБезПовторяемых = НастройкиИерархии.Скопировать(МассивИерархия);
	ШагиПовторяемые = НастройкиИерархии.Скопировать(МассивШаговПовторяемые);
	ИерархияПовторяемые = НастройкиИерархии.Скопировать(МассивИерархияПовторяемые);
	
	ВнешнийНабор = Новый Структура("Шаги, Иерархия", ШагиБезПовторяемых, ИерархияБезПовторяемых);
	
	СКД = Документы.ПроцессПодготовкиБюджетов.ПолучитьМакет("ДеревоШагов");
	Компоновщик = ФинансоваяОтчетностьСервер.КомпоновщикСхемы(СКД);
	
	ДеревоШагов = ФинансоваяОтчетностьСервер.ВыгрузитьРезультатСКД(СКД, Компоновщик, ВнешнийНабор, Истина);
	ДеревоШагов.Строки.Сортировать("Код", Истина);
	ДеревоШагов.Колонки.Добавить("ЭтапПодготовкиБюджетовОснование", Новый ОписаниеТипов("СправочникСсылка.ЭтапыПодготовкиБюджетов"));
	
	СтруктураПоиска = Новый Структура("ЭтапПодготовкиБюджетовДействие", Перечисления.ТипыДействийЭтаповПодготовкиБюджетов.ПовторГруппыЭтапов);
	ПовторяемыеГруппы = ДеревоШагов.Строки.НайтиСтроки(СтруктураПоиска, Истина);
	
	СКД = Документы.ПроцессПодготовкиБюджетов.ПолучитьМакет("ДеревоПовторяемыхШагов");
	Компоновщик = ФинансоваяОтчетностьСервер.КомпоновщикСхемы(СКД);
	
	Для Каждого СтрокаПовторяемыхГрупп Из ПовторяемыеГруппы Цикл
		
		СтрокаПовторяемыхГрупп.ЭтоГруппа = Истина;
		НастройкаДействия = СтрокаПовторяемыхГрупп.ЭтапПодготовкиБюджетовНастройкаДействия; // ХранилищеЗначения
		ЗначениеНастройкиДействия = НастройкаДействия.Получить();
		СтрокаДействия = ЗначениеНастройкиДействия.Найти("ГруппаШагов", "Имя");
		СтрокаПовторяемыхГрупп.Периодичность = СтрокаДействия.Значение.Периодичность;
		
		ЭтапПодготовкиБюджета = Новый Структура("ЭтапПодготовкиБюджетов", СтрокаПовторяемыхГрупп.ЭтапПодготовкиБюджетов);
		
		ВнешнийНабор = Новый Структура;
		ВнешнийНабор.Вставить("Шаги", ШагиПовторяемые.Скопировать(ЭтапПодготовкиБюджета));
		ВнешнийНабор.Вставить("Иерархия", ИерархияПовторяемые.Скопировать(ЭтапПодготовкиБюджета));
		
		ФинансоваяОтчетностьСервер.УстановитьПараметрКомпоновки(Компоновщик, "ПовторяемыйШаг", СтрокаПовторяемыхГрупп.ЭтапПодготовкиБюджетов);
		ДеревоПовторяемыхШагов = ФинансоваяОтчетностьСервер.ВыгрузитьРезультатСКД(СКД, Компоновщик, ВнешнийНабор, Истина);
		ДеревоПовторяемыхШагов.Строки.Сортировать("Код", Истина);
		СкопироватьДеревоПовторяемыхШагов(СтрокаПовторяемыхГрупп.Строки,
			ДеревоПовторяемыхШагов.Строки,
			СтрокаПовторяемыхГрупп.ЭтапПодготовкиБюджетов);
		
	КонецЦикла;
		
	Возврат ДеревоШагов;
	
КонецФункции

Функция ДеревоЭтаповПроцессаПоДокументу(ДокументОбъект) Экспорт
	
	ТаблицаРеквизитов = ДокументОбъект.НастройкиИерархии.Выгрузить();
	ДеревоШагов = ИерархияЭтаповПроцессаПоДокументу(ТаблицаРеквизитов);
	
	НовоеДерево = Новый ДеревоЗначений;
	Для Каждого Колонка Из ДеревоШагов.Колонки Цикл
		НовоеДерево.Колонки.Добавить(Колонка.Имя, Колонка.ТипЗначения);
	КонецЦикла;
	
	НовоеДерево.Колонки.Добавить("Ответственный");
	НовоеДерево.Колонки.Добавить("Длительность");
	НовоеДерево.Колонки.Добавить("ТипДлительности");
	НовоеДерево.Колонки.Добавить("НеВыполняется");
	НовоеДерево.Колонки.Добавить("Период");
	НовоеДерево.Колонки.Добавить("ПредставлениеПериода");
	НовоеДерево.Колонки.Добавить("Наименование");
	НовоеДерево.Колонки.Добавить("ИндексКартинки", ОбщегоНазначения.ОписаниеТипаЧисло(1));
	НовоеДерево.Колонки.Добавить("ИндексСтатуса", ОбщегоНазначения.ОписаниеТипаЧисло(1));
	НовоеДерево.Колонки.Добавить("ВыполнятьАвтоматически");
	
	ТаблицаНастроек = ДокументОбъект.НастройкиРасчета.Выгрузить(); // ТаблицаЗначений -
	ТаблицаНастроек.Индексы.Добавить("Период, ЭтапПодготовкиБюджетов");
	
	ОбойтиЗаполнитьДатыГруппДерева(НовоеДерево.Строки, ДеревоШагов.Строки, 
			ДокументОбъект.НачалоПериода, ДокументОбъект.КонецПериода, ДокументОбъект.Периодичность, ТаблицаНастроек);
	
	Возврат НовоеДерево;
	
КонецФункции

#КонецОбласти

#КонецЕсли