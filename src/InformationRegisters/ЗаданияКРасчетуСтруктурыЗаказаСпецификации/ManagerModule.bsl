#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Временное хранилище
// - следует использовать для добавления заданий вне процесса расчета

// Добавляет задания к расчету структуры заказа на производство
// 
// Параметры:
// 	МенеджерВременныхТаблиц - МенеджерВременныхТаблиц - менеджер временных таблиц
// 	ИмяВременнойТаблицы - Строка - имя временной таблице в менеджере
// 	УничтожитьВременнуюТаблицу - Булево - признак, нужно удалить временную
Процедура ДобавитьЗаданияИзМенеджераВременныхТаблиц(МенеджерВременныхТаблиц, ИмяВременнойТаблицы = "ЗаданияКРасчетуСтруктурыЗаказаСпецификации", УничтожитьВременнуюТаблицу = Ложь) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	&Очередь                    КАК Очередь,
	|	&Разделитель                КАК Разделитель,
	|	Таблица.Спецификация        КАК Спецификация,
	|	Таблица.ЗаказНаПроизводство КАК ЗаказНаПроизводство
	|ИЗ
	|	РегистрСведений.ЗаданияКРасчетуСтруктурыЗаказаСпецификации КАК Таблица
	|";
	Запрос.УстановитьПараметр("Разделитель", Новый УникальныйИдентификатор);
	Запрос.УстановитьПараметр("Очередь", Константы.ГраницаРасчетаСтруктурыЗаказов.ТекущаяОчередь());
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "РегистрСведений.ЗаданияКРасчетуСтруктурыЗаказаСпецификации", ИмяВременнойТаблицы);
	
	Если УничтожитьВременнуюТаблицу Тогда
		ТекстЗапроса = ТекстЗапроса + ";" + " " + "УНИЧТОЖИТЬ" + " " + ИмяВременнойТаблицы;
	КонецЕсли;
	
	Запрос.Текст = ТекстЗапроса;
	
	Таблица = Запрос.Выполнить().Выгрузить();
	
	НаборЗаписей = РегистрыСведений.БуферЗаданийКРасчетуСтруктурыЗаказаСпецификации.СоздатьНаборЗаписей();
	НаборЗаписей.Загрузить(Таблица);
	НаборЗаписей.Записать(Ложь);
	
КонецПроцедуры

// Добавляет задания к расчету структуры заказа на производство
// 
// Параметры:
// 	Таблица - ТаблицаЗначений - задания к расчету.
// 	НужноСвернуть - Булево - признак, необходимо свернуть таблицу перед записью заданий.
//
Процедура ДобавитьЗадания(Таблица, НужноСвернуть = Ложь) Экспорт

	УстановитьПривилегированныйРежим(Истина);

	НаборЗаписей = РегистрыСведений.БуферЗаданийКРасчетуСтруктурыЗаказаСпецификации.СоздатьНаборЗаписей();
	
	Если НужноСвернуть Тогда
		ПоляГруппировки = "Спецификация, ЗаказНаПроизводство";
		Таблица.Свернуть(ПоляГруппировки); // сохранение ресурсов не поддерживается
	КонецЕсли;
	
	КолонкиПоЗначению = Новый Структура("Очередь", Константы.ГраницаРасчетаСтруктурыЗаказов.ТекущаяОчередь());
	
	СтруктураЗаказа.ЗаполнитьИЗаписатьНаборЗаписей(
		НаборЗаписей,
		Таблица,
		Ложь,
		Истина,
		КолонкиПоЗначению);
	
КонецПроцедуры

// Добавляет задания к расчету структуры заказа на производство
// 
// Параметры:
// 	Спецификация		 - СправочникСсылка.РесурсныеСпецификации	- спецификация.
// 	ЗаказНаПроизводство	 - ДокументСсылка.ЗаказНаПроизводство2_2	- заказ на производство.
// 	Задания				 - ТаблицаЗначений 							- если таблица передана, задания добавляются в таблицу, иначе записываются в базу данных.
//
Процедура ДобавитьЗадание(Спецификация, ЗаказНаПроизводство, Задания = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Задания <> Неопределено Тогда
	
		НоваяЗапись = Задания.Добавить();
		
		НоваяЗапись.Спецификация = Спецификация;
		НоваяЗапись.ЗаказНаПроизводство = ЗаказНаПроизводство;
		
	Иначе
	
		НаборЗаписей = РегистрыСведений.БуферЗаданийКРасчетуСтруктурыЗаказаСпецификации.СоздатьНаборЗаписей();
		
		НоваяЗапись = НаборЗаписей.Добавить();
		
		НоваяЗапись.Очередь = Константы.ГраницаРасчетаСтруктурыЗаказов.ТекущаяОчередь();
		НоваяЗапись.Разделитель = Новый УникальныйИдентификатор();
		
		НоваяЗапись.Спецификация = Спецификация;
		НоваяЗапись.ЗаказНаПроизводство = ЗаказНаПроизводство;
		
		НаборЗаписей.Записать(Ложь);

	КонецЕсли;

КонецПроцедуры

// Добавляет задания к расчету структуры заказа на производство
// 
// Параметры:
// 	Таблица - ТаблицаЗначений - задания к расчету.
// 	НужноСвернуть - Булево - признак, необходимо свернуть таблицу перед записью заданий.
//
Процедура ДобавитьЗаданияПолныйРасчет(Таблица, НужноСвернуть = Ложь) Экспорт

	УстановитьПривилегированныйРежим(Истина);
	
	НаборЗаписей = РегистрыСведений.БуферЗаданийКРасчетуСтруктурыЗаказаСпецификации.СоздатьНаборЗаписей();
	
	Если НужноСвернуть Тогда
		ПоляГруппировки = "Спецификация, ЗаказНаПроизводство";
		Таблица.Свернуть(ПоляГруппировки); // сохранение ресурсов не поддерживается
	КонецЕсли;
	
	КолонкиПоЗначению = Новый Структура("Очередь, ПолныйРасчет", Константы.ГраницаРасчетаСтруктурыЗаказов.ТекущаяОчередь(), Истина);
	
	СтруктураЗаказа.ЗаполнитьИЗаписатьНаборЗаписей(
		НаборЗаписей,
		Таблица,
		Ложь,
		Истина,
		КолонкиПоЗначению);
	
КонецПроцедуры

// Добавляет задания к расчету структуры заказа на производство
// 
// Параметры:
// 	Спецификация		 - СправочникСсылка.РесурсныеСпецификации	- спецификация.
// 	ЗаказНаПроизводство	 - ДокументСсылка.ЗаказНаПроизводство2_2	- заказ на производство.
// 	Задания				 - ТаблицаЗначений 							- если таблица передана, задания добавляются в таблицу, иначе записываются в базу данных.
//
Процедура ДобавитьЗаданиеПолныйРасчет(Спецификация, ЗаказНаПроизводство, Задания = Неопределено) Экспорт

	УстановитьПривилегированныйРежим(Истина);
	
	Если Задания <> Неопределено Тогда
	
		НоваяЗапись = Задания.Добавить();
		
		НоваяЗапись.Спецификация = Спецификация;
		НоваяЗапись.ЗаказНаПроизводство = ЗаказНаПроизводство;
		
	Иначе
	
		НаборЗаписей = РегистрыСведений.БуферЗаданийКРасчетуСтруктурыЗаказаСпецификации.СоздатьНаборЗаписей();
		
		НоваяЗапись = НаборЗаписей.Добавить();
		
		НоваяЗапись.Очередь = Константы.ГраницаРасчетаСтруктурыЗаказов.ТекущаяОчередь();
		НоваяЗапись.Разделитель = Новый УникальныйИдентификатор();
		
		НоваяЗапись.Спецификация = Спецификация;
		НоваяЗапись.ЗаказНаПроизводство = ЗаказНаПроизводство;
		
		НоваяЗапись.ПолныйРасчет = Истина;
		
		НаборЗаписей.Записать(Ложь);

	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Итоговая очередь заданий к расчету
// - может использоваться для добавления заданий в процессе расчета

// Добавляет задания к расчету структуры заказа на производство в конец очереди (только для добавления заданий в процессе расчета)
// 
// Параметры:
// 	Таблица - ТаблицаЗначений - задания к расчету.
// 	НужноСвернуть - Булево - признак, необходимо свернуть таблицу перед записью заданий.
//
Процедура ДобавитьЗаданияВКонецОчереди(Таблица, НужноСвернуть = Ложь) Экспорт

	УстановитьПривилегированныйРежим(Истина);

	НаборЗаписей = РегистрыСведений.ЗаданияКРасчетуСтруктурыЗаказаСпецификации.СоздатьНаборЗаписей();
	
	Если НужноСвернуть Тогда
		ПоляГруппировки = "Спецификация, ЗаказНаПроизводство";
		Таблица.Свернуть(ПоляГруппировки); // сохранение ресурсов не поддерживается
	КонецЕсли;
	
	КолонкиПоЗначению = Новый Структура("Очередь", Константы.ГраницаРасчетаСтруктурыЗаказов.ТекущаяОчередь());
	
	СтруктураЗаказа.ЗаполнитьИЗаписатьНаборЗаписей(
		НаборЗаписей,
		Таблица,
		Ложь,
		Истина,
		КолонкиПоЗначению);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Выбирает изменения из очереди и возращает номер очереди, в котором есть необработанные задания
// 
// Возвращаемое значение:
// 	Число - номер очереди
Функция ВыбратьИзменения(ГраницаРасчета) Экспорт

	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	&Граница                       КАК Очередь,
	|	&Разделитель                   КАК Разделитель,
	|	Таблица.Спецификация           КАК Спецификация,
	|	Таблица.ЗаказНаПроизводство    КАК ЗаказНаПроизводство,
	|	МАКСИМУМ(Таблица.ПолныйРасчет) КАК ПолныйРасчет
	|ИЗ
	|	РегистрСведений.БуферЗаданийКРасчетуСтруктурыЗаказаСпецификации КАК Таблица
	|ГДЕ 
	|	Таблица.Очередь <= &Граница
	|
	|СГРУППИРОВАТЬ ПО
	|	Таблица.Спецификация, Таблица.ЗаказНаПроизводство
	|;
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Таблица.Очередь КАК Очередь
	|ИЗ
	|	РегистрСведений.БуферЗаданийКРасчетуСтруктурыЗаказаСпецификации КАК Таблица
	|ГДЕ
	|	Таблица.Очередь <= &Граница
	|;
	|";
	Запрос.УстановитьПараметр("Граница", ГраницаРасчета);
	Запрос.УстановитьПараметр("Разделитель", Новый УникальныйИдентификатор);
	
	НачатьТранзакцию();
	Попытка
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.БуферЗаданийКРасчетуСтруктурыЗаказаСпецификации");
		ЭлементБлокировки.УстановитьЗначение("Очередь", Новый Диапазон(, ГраницаРасчета));
		Блокировка.Заблокировать();
		
		Результат = Запрос.ВыполнитьПакет();
		
		Если Не Результат[0].Пустой() Тогда
			
			Таблица = Результат[0].Выгрузить();
			
			Набор = РегистрыСведений.ЗаданияКРасчетуСтруктурыЗаказаСпецификации.СоздатьНаборЗаписей();
			Набор.Загрузить(Таблица);
			Набор.Записать(Ложь);
			
			СписокОчередей = Результат[1].Выгрузить().ВыгрузитьКолонку(0);
			
			Для каждого Очередь Из СписокОчередей Цикл
			
				Набор = РегистрыСведений.БуферЗаданийКРасчетуСтруктурыЗаказаСпецификации.СоздатьНаборЗаписей();
				Набор.Отбор.Очередь.Установить(Очередь);
				Набор.Записать(Истина);
				
			КонецЦикла;
			
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(СтруктураЗаказа.ИмяСобытияЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,,, 
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение;
	КонецПопытки;
	
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Таблица.Очередь КАК Очередь
	|ИЗ
	|	РегистрСведений.ЗаданияКРасчетуСтруктурыЗаказаСпецификации КАК Таблица
	|ГДЕ
	|	Таблица.Очередь <= &Граница
	|УПОРЯДОЧИТЬ ПО
	|	Очередь ВОЗР";
	РезультатЗапроса = Запрос.Выполнить();
	
	НомерОчереди = ?(РезультатЗапроса.Пустой(), 0, РезультатЗапроса.Выгрузить()[0].Очередь);
	
	Возврат НомерОчереди;
	
КонецФункции

// Удаляет задания по номеру очереди
// 
// Параметры:
// 	Очередь - Число - номер очереди
Процедура УдалитьЗадания(Очередь) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Набор = РегистрыСведений.ЗаданияКРасчетуСтруктурыЗаказаСпецификации.СоздатьНаборЗаписей();
	Набор.Отбор.Очередь.Установить(Очередь);
	Набор.Записать(Истина);
	
КонецПроцедуры

// Возвращает новую таблицу заданий
// 
// Возвращаемое значение:
// 	ТаблицаЗначений - Описание
//
Функция ТаблицаЗаданий() Экспорт
	
	Таблица = РегистрыСведений.ЗаданияКРасчетуСтруктурыЗаказаСпецификации.СоздатьНаборЗаписей().ВыгрузитьКолонки("Спецификация,ЗаказНаПроизводство");
	Возврат Таблица;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолноеИмя() Экспорт

	ПолноеИмя = Метаданные.РегистрыСведений.ЗаданияКРасчетуСтруктурыЗаказаСпецификации.ПолноеИмя();

	Возврат ПолноеИмя;

КонецФункции

#КонецОбласти

#КонецЕсли