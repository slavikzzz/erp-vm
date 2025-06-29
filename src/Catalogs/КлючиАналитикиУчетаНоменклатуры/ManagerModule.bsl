#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Соответствие со списком реквизитов, по которым определяется уникальность ключа
// 
// Возвращаемое значение:
//   Соответствие - ключ - имя реквизита 
//
Функция КлючевыеРеквизиты() Экспорт
	
	Возврат ОбщегоНазначенияУТ.КлючевыеРеквизитыСправочникаКлючейПоРегиструСведений(Метаданные.РегистрыСведений.АналитикаУчетаНоменклатуры);
	
КонецФункции

#КонецОбласти
	
#Область СлужебныеПроцедурыИФункции

#Область ЗаменаДублейКлючейАналитики

// Заменить дубли ключей аналитики.
// 
// Параметры:
//  КоличествоКлючей - Число - Количество ключей
// 
// Возвращаемое значение:
//  Структура - Заменить дубли ключей аналитики:
// * ВремяВыполнения - Число - время выполнения, в секундах
// * ОбработаноКлючей - Число - количество обработанных дублей ключей
// * ОбработаноДокументов - Число - количество обработанных документов с движениями по регистру СтоимостьТоваров
//
Функция ЗаменитьДублиКлючейАналитики(КоличествоКлючей = Неопределено) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ВремяВыполнения", ТекущаяУниверсальнаяДатаВМиллисекундах());
	Результат.Вставить("ОбработаноКлючей", 0);
	Результат.Вставить("ОбработаноДокументов", 0);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	// Выберем дубли ключей аналитики.
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеСправочника.Ссылка КАК Ссылка,
	|	ДанныеСправочника.ПометкаУдаления КАК ПометкаУдаления,
	|	Аналитика.КлючАналитики КАК КлючАналитики
	|ПОМЕСТИТЬ ДублиКлючей
	|ИЗ
	|	Справочник.КлючиАналитикиУчетаНоменклатуры КАК ДанныеСправочника
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.АналитикаУчетаНоменклатуры КАК ДанныеРегистра
	|	ПО
	|		ДанныеСправочника.Ссылка = ДанныеРегистра.КлючАналитики
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
	|	ПО
	|		ДанныеСправочника.Номенклатура		= Аналитика.Номенклатура
	|		И ДанныеСправочника.Характеристика	= Аналитика.Характеристика
	|		И ДанныеСправочника.Серия			= Аналитика.Серия
	|		И ДанныеСправочника.МестоХранения	= Аналитика.МестоХранения
	|		И ДанныеСправочника.Назначение		= Аналитика.Назначение
	|		И ДанныеСправочника.СтатьяКалькуляции = Аналитика.СтатьяКалькуляции
	|ГДЕ
	|	ДанныеРегистра.КлючАналитики ЕСТЬ NULL
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|";
	
	Запрос.Выполнить();
	
	// Очистим движения регистра СтоимостьТоваров по дублям ключей (по всем дублям, не зависимо от их пометки на удаление)
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СтоимостьТоваров.Регистратор КАК Регистратор
	|ИЗ
	|	РегистрСведений.СтоимостьТоваров КАК СтоимостьТоваров
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ДублиКлючей КАК Т
	|		ПО СтоимостьТоваров.АналитикаУчетаНоменклатуры = Т.Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	Регистратор
	|АВТОУПОРЯДОЧИВАНИЕ";
	
	Регистраторы = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Регистратор");
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	*
	|ИЗ
	|	РегистрСведений.СтоимостьТоваров КАК Т
	|	ЛЕВОЕ СОЕДИНЕНИЕ ДублиКлючей КАК Дубли
	|		ПО Т.АналитикаУчетаНоменклатуры = Дубли.Ссылка
	|ГДЕ
	|	Т.Регистратор = &Регистратор
	|	И Дубли.Ссылка ЕСТЬ NULL
	|
	|УПОРЯДОЧИТЬ ПО
	|	Т.НомерСтроки";
	
	РазмерПорцииДанных = РасчетСебестоимостиПовтИсп.ЗначенияТехнологическихПараметров().КоличествоСтрокВТЗ;
	
	Для Каждого Регистратор Из Регистраторы Цикл
		
		Запрос.УстановитьПараметр("Регистратор", Регистратор);
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		НаборЗаписей = РегистрыСведений.СтоимостьТоваров.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Регистратор.Установить(Регистратор);
		
		НачатьТранзакцию();
		ДвиженияЗаписаны = Ложь;
		
		Попытка
			
			Пока Выборка.Следующий() Цикл
				
				ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(), Выборка,, "НомерСтроки, Активность");
				
				Если НаборЗаписей.Количество() = РазмерПорцииДанных Тогда
					
					НаборЗаписей.Записать(НЕ ДвиженияЗаписаны);
					НаборЗаписей.Очистить();
					
					ДвиженияЗаписаны = Истина;
					
				КонецЕсли;
				
			КонецЦикла;
			
			Если НаборЗаписей.Количество() > 0 ИЛИ НЕ ДвиженияЗаписаны Тогда
				НаборЗаписей.Записать(НЕ ДвиженияЗаписаны);
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось записать движения документа ""%1"" по причине:
					|%2';
					|en = 'Cannot save the ""%1"" document register records due to:
					|%2'"),
				Регистратор,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				
			ВызватьИсключение ТекстОшибки;
			
		КонецПопытки;
		
		Результат.ОбработаноДокументов = Результат.ОбработаноДокументов + 1;
		
	КонецЦикла;
	
	// Очистим оставшиеся ссылки на дубли ключей (только по непомеченным на удаление; количество обрабатываемых ключей определяется параметром КоличествоКлючей данной функции).
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Т.Ссылка КАК Ссылка,
	|	Т.КлючАналитики КАК КлючАналитики
	|ИЗ
	|	ДублиКлючей КАК Т
	|ГДЕ
	|	НЕ Т.ПометкаУдаления
	|";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "1", ?(ЗначениеЗаполнено(КоличествоКлючей), Формат(КоличествоКлючей, "ЧГ="), "999999999"));
	
	СоответствиеАналитик = Новый Соответствие;
	
	Исключения = Новый Массив;
	Исключения.Добавить(Метаданные.РегистрыСведений.СтоимостьТоваров);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
	
		Выборка = РезультатЗапроса.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			СоответствиеАналитик.Вставить(Выборка.Ссылка, Выборка.КлючАналитики);
			Результат.ОбработаноКлючей = Результат.ОбработаноКлючей + 1;
			
			СправочникОбъект = Выборка.Ссылка.ПолучитьОбъект();
			СправочникОбъект.УстановитьПометкуУдаления(Истина, Ложь);
			
		КонецЦикла;
		
		ОбщегоНазначенияУТ.ЗаменитьСсылки(СоответствиеАналитик, Исключения);
		
	КонецЕсли;
	
	Результат.ВремяВыполнения = (ТекущаяУниверсальнаяДатаВМиллисекундах() - Результат.ВремяВыполнения) / 1000;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

#КонецОбласти

#КонецОбласти

#КонецЕсли