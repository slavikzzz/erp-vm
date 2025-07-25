	
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.Декорация1.Заголовок = "Помощник перехода на новые начисления оплаты по среднему/денежному содержанию (довольствию) позволяет поместить в архив существующие начисления и создать вместо них новые. 
	|Вместо одного старого начисления создается одно так называемое ""основное начисление"" (копия помещаемого в архив) с измененной формулой. И дополнительно создаются два начисления с категориями оплаты долей районного коэффициента, северной надбавки в среднем заработке/денежном содержании (довольствии)";
	
	Элементы.ОтборПоКатегории.СписокВыбора.ЗагрузитьЗначения(КатегорииОплатПоСреднему());
	//Оплата времени кормления
	Элементы.ОтборПоКатегории.СписокВыбора.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ПовременнаяОплатаТруда,  "Оплата времени кормления ребенка");
	
	ОтпускУчебный = ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.ВидыОтпусков.ОтпускУчебный");
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьВидыРасчета(Команда)
		
	Оповещение = Новый ОписаниеОповещения("СоздатьВидыРасчетаЗавершение", ЭтотОбъект);
	ТекстВопроса = НСтр("ru = 'Выбранные виды расчета поместятся в архив. Будут созданы новые виды расчета. 
	|Выполнить?';
	|en = 'Выбранные виды расчета поместятся в архив. Будут созданы новые виды расчета. 
	|Выполнить?'");
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьВидыРасчетаЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда 
		Возврат;
	КонецЕсли;
		
	ДлительнаяОперация = ДлительнаяОперацияСозданияВидовРасчета(УникальныйИдентификатор);
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ОбработатьРезультатСоздания", ЭтотОбъект);
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
	
КонецПроцедуры

&НаСервере
Функция ДлительнаяОперацияСозданияВидовРасчета(УникальныйИдентификатор)
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияФункции(УникальныйИдентификатор);
	
	ДанныеОсновныхВидовРасчета = ОсновныеВидыРасчета.Выгрузить();
	
	ОсновныеВидыРасчета.Очистить();
	СозданныеВидыРасчета.Очистить();
	ПомещенныеВАрхивВидыРасчета.Очистить();
	
	Возврат ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполнения, "Обработки.ПомощникПереходаНаНовыеНачисленияОплатПоСреднему.СоздатьВидыРасчета",
		ДанныеОсновныхВидовРасчета);
	
КонецФункции
	
&НаКлиенте
Процедура ОбработатьРезультатСоздания(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Ошибка" Тогда
		ВызватьИсключение Результат.КраткоеПредставлениеОшибки;
	КонецЕсли;
	
	Если Результат.АдресРезультата = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РезультатВыполнения = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
	Если РезультатВыполнения.Свойство("СозданныеВидыРасчета") Тогда	
		Для Каждого ЭлементКоллекции Из РезультатВыполнения.СозданныеВидыРасчета Цикл	
			НоваяСтрока = СозданныеВидыРасчета.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ЭлементКоллекции); 	
		КонецЦикла;	
	КонецЕсли;
	
	Если РезультатВыполнения.Свойство("ПомещенныеВАрхивВидыРасчета") Тогда	
		Для Каждого ЭлементКоллекции Из РезультатВыполнения.ПомещенныеВАрхивВидыРасчета Цикл	
			НоваяСтрока = ПомещенныеВАрхивВидыРасчета.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ЭлементКоллекции);	
		КонецЦикла;	
	КонецЕсли;
	
	ОсновныеВидыРасчета.Очистить();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	ИзменитьФлажки(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	ИзменитьФлажки(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьФлажки(Установить)

	Для Каждого Стр Из ОсновныеВидыРасчета Цикл
		Стр.ОбрабатыватьВидРасчета = Установить;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьВидыРасчета(Команда)
	
	ОсновныеВидыРасчета.Очистить();
	СозданныеВидыРасчета.Очистить();
	ПомещенныеВАрхивВидыРасчета.Очистить();
	
	ЗаполнитьВидыРасчетаНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВидыРасчетаНаСервере()
			
	Если ЗначениеЗаполнено(ОтборПоКатегории) Тогда
		КатегорииОплатПоСреднему = ОтборПоКатегории;
	Иначе
		КатегорииОплатПоСреднему = КатегорииОплатПоСреднему();
	КонецЕсли;
	
	ВидВремениЗадержкаВыплатыЗаработнойПлаты = ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.ВидыИспользованияРабочегоВремени.ЗадержкаВыплатыЗаработнойПлаты");
	ВидВремениКормлениеРебенка = ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.ВидыИспользованияРабочегоВремени.КормлениеРебенка");

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Начисления.Ссылка КАК ДополнительныйВидРасчета,
	               |	Начисления.ОсновнойВидРасчета КАК ОсновнойВидРасчета
	               |ПОМЕСТИТЬ ВТДополнительныеВидыРасчетаРК
	               |ИЗ
	               |	ПланВидовРасчета.Начисления КАК Начисления
	               |ГДЕ
	               |	Начисления.КатегорияНачисленияИлиНеоплаченногоВремени В(&КатегорииНачисленийРК)
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	Начисления.Ссылка КАК ДополнительныйВидРасчета,
	               |	Начисления.ОсновнойВидРасчета КАК ОсновнойВидРасчета
	               |ПОМЕСТИТЬ ВТДополнительныеВидыРасчетаСН
	               |ИЗ
	               |	ПланВидовРасчета.Начисления КАК Начисления
	               |ГДЕ
	               |	Начисления.КатегорияНачисленияИлиНеоплаченногоВремени В(&КатегорииНачисленийСН)
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	Начисления.Ссылка КАК ОсновнойВидРасчета,
	               |	Начисления.КатегорияНачисленияИлиНеоплаченногоВремени КАК КатегорияНачисления,
	               |	ВЫБОР
	               |		КОГДА ВТДополнительныеВидыРасчетаРК.ДополнительныйВидРасчета ЕСТЬ NULL
	               |			ТОГДА ИСТИНА
	               |		ИНАЧЕ ЛОЖЬ
	               |	КОНЕЦ КАК ТребуетсяВидРасчетаРК,
	               |	ВЫБОР
	               |		КОГДА ВТДополнительныеВидыРасчетаСН.ДополнительныйВидРасчета ЕСТЬ NULL
	               |			ТОГДА ИСТИНА
	               |		ИНАЧЕ ЛОЖЬ
	               |	КОНЕЦ КАК ТребуетсяВидРасчетаСН,
	               |	Начисления.ВидВремени КАК ВидВремени,
	               |	Начисления.ВидОтпуска КАК ВидОтпуска,
	               |	Начисления.ОбозначениеВТабелеУчетаРабочегоВремени КАК ОбозначениеВТабелеУчетаРабочегоВремени
	               |ИЗ
	               |	ПланВидовРасчета.Начисления КАК Начисления
	               |		ЛЕВОЕ СОЕДИНЕНИЕ ВТДополнительныеВидыРасчетаРК КАК ВТДополнительныеВидыРасчетаРК
	               |		ПО Начисления.Ссылка = ВТДополнительныеВидыРасчетаРК.ОсновнойВидРасчета
	               |		ЛЕВОЕ СОЕДИНЕНИЕ ВТДополнительныеВидыРасчетаСН КАК ВТДополнительныеВидыРасчетаСН
	               |		ПО Начисления.Ссылка = ВТДополнительныеВидыРасчетаСН.ОсновнойВидРасчета
	               |ГДЕ
				   |	&УсловиеПоКатегориям
				   |	И Начисления.КодДоходаНДФЛ <> ЗНАЧЕНИЕ(Справочник.ВидыДоходовНДФЛ.ПустаяСсылка)
	               |	И НЕ Начисления.ПометкаУдаления
	               |	И НЕ Начисления.ВАрхиве
	               |	И ВТДополнительныеВидыРасчетаРК.ДополнительныйВидРасчета ЕСТЬ NULL
	               |	И ВТДополнительныеВидыРасчетаСН.ДополнительныйВидРасчета ЕСТЬ NULL";
	
	Запрос.УстановитьПараметр("КатегорииОплатПоСреднему", КатегорииОплатПоСреднему);
	Запрос.УстановитьПараметр("ВидВремениКормлениеРебенка", ВидВремениКормлениеРебенка);
	Запрос.УстановитьПараметр("КатегорииНачисленийРК", ПланыВидовРасчета.Начисления.КатегорииНачисленийОплатыДолиРК());
	Запрос.УстановитьПараметр("КатегорииНачисленийСН", ПланыВидовРасчета.Начисления.КатегорииНачисленийОплатыДолиСН());
	
	УсловиеПоКатегориям = "(Начисления.КатегорияНачисленияИлиНеоплаченногоВремени В (&КатегорииОплатПоСреднему)
				   |	ИЛИ Начисления.КатегорияНачисленияИлиНеоплаченногоВремени = ЗНАЧЕНИЕ(Перечисление.КатегорииНачисленийИНеоплаченногоВремени.ПовременнаяОплатаТруда)
				   |	И Начисления.ОбозначениеВТабелеУчетаРабочегоВремени = &ВидВремениКормлениеРебенка)";
	Если КатегорииОплатПоСреднему = Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ПовременнаяОплатаТруда Тогда
		УсловиеПоКатегориям = "Начисления.КатегорияНачисленияИлиНеоплаченногоВремени = ЗНАЧЕНИЕ(Перечисление.КатегорииНачисленийИНеоплаченногоВремени.ПовременнаяОплатаТруда)
							|И Начисления.ОбозначениеВТабелеУчетаРабочегоВремени = &ВидВремениКормлениеРебенка";
	ИначеЕсли ТипЗнч(КатегорииОплатПоСреднему) <> Тип("Массив") Тогда
		УсловиеПоКатегориям = "Начисления.КатегорияНачисленияИлиНеоплаченногоВремени В (&КатегорииОплатПоСреднему)";
	КонецЕсли;
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеПоКатегориям", УсловиеПоКатегориям);
	
    РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	
	СвойстваКатегорийНачислений = ПланыВидовРасчета.Начисления.СвойстваНачисленийПоКатегориям();
	
	Пока Выборка.Следующий() Цикл
		
		СвойстваПоКатегории = СвойстваКатегорийНачислений.Получить(Выборка.КатегорияНачисления);
		НоваяСтрока = ОсновныеВидыРасчета.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		Если Выборка.КатегорияНачисления = Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаОтпуска И Выборка.ВидОтпуска = ОтпускУчебный Тогда
			НоваяСтрока.НоваяФормулаРасчета = "?((СреднийЗаработокИндексируемый * КоэффициентИндексацииСреднегоЗаработка + СреднийЗаработокНеиндексируемый) * КалендарныеДниМесяца > УчитыватьМРОТ * МРОТ, ((СреднийЗаработокИндексируемый * КоэффициентИндексацииСреднегоЗаработка + СреднийЗаработокНеиндексируемый) - (СреднийЗаработокИндексируемыйРК * КоэффициентИндексацииСреднегоЗаработка + СреднийЗаработокНеиндексируемыйРК) - (СреднийЗаработокИндексируемыйСН * КоэффициентИндексацииСреднегоЗаработка + СреднийЗаработокНеиндексируемыйСН))* КалендарныеДниМесяца, УчитыватьМРОТ * МРОТ) / КалендарныеДниМесяца * КоличествоДнейОтпуска";
		ИначеЕсли Выборка.КатегорияНачисления = Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаКомандировки 
			И Выборка.ВидВремени = Перечисления.ВидыРабочегоВремениСотрудников.ЧасовоеНеотработанное Тогда
			НоваяСтрока.НоваяФормулаРасчета = "?((СреднийЗаработокИндексируемый * КоэффициентИндексацииСреднегоЗаработка + СреднийЗаработокНеиндексируемый) * НормаЧасов > УчитыватьМРОТ * МРОТ, ((СреднийЗаработокИндексируемый * КоэффициентИндексацииСреднегоЗаработка + СреднийЗаработокНеиндексируемый) - (СреднийЗаработокИндексируемыйРК * КоэффициентИндексацииСреднегоЗаработка + СреднийЗаработокНеиндексируемыйРК) - (СреднийЗаработокИндексируемыйСН * КоэффициентИндексацииСреднегоЗаработка + СреднийЗаработокНеиндексируемыйСН)) * НормаЧасов, УчитыватьМРОТ * МРОТ) / НормаЧасов * ВремяВЧасах";
		ИначеЕсли Выборка.ОбозначениеВТабелеУчетаРабочегоВремени = ВидВремениЗадержкаВыплатыЗаработнойПлаты И
			Выборка.КатегорияНачисления = Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаПростояПоВинеРаботодателя Тогда
			НоваяСтрока.НоваяФормулаРасчета = "?((СреднийЗаработокИндексируемый * КоэффициентИндексацииСреднегоЗаработка + СреднийЗаработокНеиндексируемый) * НормаДнейЧасов > УчитыватьМРОТ * МРОТ, ((СреднийЗаработокИндексируемый * КоэффициентИндексацииСреднегоЗаработка + СреднийЗаработокНеиндексируемый) - (СреднийЗаработокИндексируемыйРК * КоэффициентИндексацииСреднегоЗаработка + СреднийЗаработокНеиндексируемыйРК) - (СреднийЗаработокИндексируемыйСН * КоэффициентИндексацииСреднегоЗаработка + СреднийЗаработокНеиндексируемыйСН)) * НормаДнейЧасов, УчитыватьМРОТ * МРОТ) / НормаДнейЧасов * ВремяВДняхЧасах";	
		ИначеЕсли Выборка.КатегорияНачисления = Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаПростояПоВинеРаботодателя 
			И Выборка.ВидВремени = Перечисления.ВидыРабочегоВремениСотрудников.ЧасовоеНеотработанное Тогда
			НоваяСтрока.НоваяФормулаРасчета = "?((СреднийЗаработокИндексируемый * КоэффициентИндексацииСреднегоЗаработка + СреднийЗаработокНеиндексируемый) * НормаЧасов > УчитыватьМРОТ * МРОТ, ((СреднийЗаработокИндексируемый * КоэффициентИндексацииСреднегоЗаработка + СреднийЗаработокНеиндексируемый) - (СреднийЗаработокИндексируемыйРК * КоэффициентИндексацииСреднегоЗаработка + СреднийЗаработокНеиндексируемыйРК) - (СреднийЗаработокИндексируемыйСН * КоэффициентИндексацииСреднегоЗаработка + СреднийЗаработокНеиндексируемыйСН)) * НормаЧасов, УчитыватьМРОТ * МРОТ) / НормаЧасов * (2/3) * ВремяВЧасах";
		ИначеЕсли Выборка.ОбозначениеВТабелеУчетаРабочегоВремени = ВидВремениКормлениеРебенка И
			Выборка.КатегорияНачисления = Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ПовременнаяОплатаТруда Тогда
			НоваяСтрока.НоваяФормулаРасчета = "?(СреднийЗаработокОбщий * НормаЧасов > УчитыватьМРОТ * МРОТ, (СреднийЗаработокОбщий - СреднийЗаработокРК - СреднийЗаработокСН) * НормаЧасов, УчитыватьМРОТ * МРОТ) / НормаЧасов * ВремяВЧасах";
		Иначе
			НоваяСтрока.НоваяФормулаРасчета = СвойстваПоКатегории.ФормулаРасчета;
		КонецЕсли;
					
	КонецЦикла;
			
КонецПроцедуры

&НаКлиенте
Процедура Очистить(Команда)
	
	ОсновныеВидыРасчета.Очистить();
	СозданныеВидыРасчета.Очистить();
	ПомещенныеВАрхивВидыРасчета.Очистить();
	
КонецПроцедуры

&НаСервере
Функция КатегорииОплатПоСреднему()
	
	КатегорииОплатПоСреднему = Новый Массив;
	КатегорииОплатПоСреднему.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаОтпуска);
	КатегорииОплатПоСреднему.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ДенежноеСодержаниеНаПериодОтпуска);
	КатегорииОплатПоСреднему.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.КомпенсацияОтпуска);
	КатегорииОплатПоСреднему.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ДенежноеСодержаниеКомпенсацияОтпуска);
	КатегорииОплатПоСреднему.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаКомандировки);
	КатегорииОплатПоСреднему.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ДенежноеСодержаниеНаПериодКомандировки);
	КатегорииОплатПоСреднему.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаПоСреднемуЗаработку);
	КатегорииОплатПоСреднему.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.СохраняемоеДенежноеСодержание);
	КатегорииОплатПоСреднему.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ДоплатаКомандировки);      
	КатегорииОплатПоСреднему.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ДенежноеСодержаниеДоплатаКомандировки);  
	КатегорииОплатПоСреднему.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ДенежноеДовольствиеКомпенсацияОтпуска);
	КатегорииОплатПоСреднему.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОтпускНаСанаторноКурортноеЛечение);  
	КатегорииОплатПоСреднему.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ВыходноеПособие);
	КатегорииОплатПоСреднему.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ВыходноеПособиеМесячноеДенежноеСодержание);  
	КатегорииОплатПоСреднему.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ДенежноеСодержаниеНаПериодОтпускаНаСанаторноКурортноеЛечение);  
	КатегорииОплатПоСреднему.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.КомпенсацияЗаНеотработанныеДниЧасыПриУвольнении);
	КатегорииОплатПоСреднему.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.КомпенсацияЗаНеотработанныеДниПриУвольненииГосслужащего);
	КатегорииОплатПоСреднему.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаПростояПоВинеРаботодателя);
	КатегорииОплатПоСреднему.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаСверхурочныхВоеннослужащим);
	КатегорииОплатПоСреднему.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.СохраняемоеДенежноеДовольствие);
	
	Возврат КатегорииОплатПоСреднему;
	
КонецФункции
