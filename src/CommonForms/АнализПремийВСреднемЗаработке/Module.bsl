
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Сотрудник = Параметры.Сотрудник;
	Организация = Параметры.Организация;
	ДатаНачалаСобытия = Параметры.ДатаНачалаСобытия;
	ПорядокРасчета = Параметры.ПорядокРасчета;
	ДокументСсылка = Параметры.ДокументСсылка;
	ДокументВладелецДанныеАдрес = Параметры.ДокументВладелецДанныеАдрес;
	
	// Заполняем период расчета среднего заработка.
	НачалоПериодаРасчета = Параметры.НачалоПериодаРасчета;
	ОкончаниеПериодаРасчета = Параметры.ОкончаниеПериодаРасчета;
	
	ЗаполнитьМесяцыРасчета(ЭтаФорма);
	
	СоздатьКолонкиПремий();
	
	УстановитьЗаголовокФормы();
	
	ДанныеОПремиях = Параметры.СведенияОПремиях;
	Если ДанныеОПремиях <> Неопределено Тогда
		ДанныеОПремиях = ПолучитьИзВременногоХранилища(ДанныеОПремиях);
	КонецЕсли;
	
	ДанныеОНачислениях = Параметры.ДанныеОНачислениях;
	Если ДанныеОНачислениях <> Неопределено Тогда
		ДанныеОНачислениях = ПолучитьИзВременногоХранилища(ДанныеОНачислениях);
	КонецЕсли;
	
	Элементы.ПредупреждениеОРазныхДанных.Видимость = Параметры.РассогласованиеДокументаИУчета;
	
	Если ЗначениеЗаполнено(ДокументВладелецДанныеАдрес) Тогда
		ДанныеПредварительногоПроведения = ПолучитьИзВременногоХранилища(ДокументВладелецДанныеАдрес);
		ВременныйРегистратор = ДанныеПредварительногоПроведения.ДокументСсылка;
	КонецЕсли;
	
	// Преобразование данных для вывода в форме.
	ЗаполнитьФорму(ДанныеОПремиях, ДанныеОНачислениях);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ВыбратьИЗакрыть", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыАнализПремий

&НаКлиенте
Процедура ФлагИсключеннойПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.АнализПремий.ТекущиеДанные;
	
	ТекущийКлючНачисления = ТекущиеДанные.КлючНачисления;
	ЗначениеФлага = ТекущиеДанные.Исключенная;
	
	ОтметитьИсключенныеНаСервере(ТекущийКлючНачисления, ЗначениеФлага, ТекущиеДанные.ПолучитьИдентификатор());
	Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда) 
	
	ВыбратьИЗакрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьИзменения(Команда)
	
	ОтменитьИзмененияНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьФорму(ДанныеОПремиях, ДанныеНачислений)
	
	СведенияОПремиях.Очистить();
	РасшифровкаСреднегоЗаработка.Очистить();
	
	ДокументыРегистраторы = ОбщегоНазначенияКлиентСервер.СвернутьМассив(ДанныеОПремиях.ВыгрузитьКолонку("Регистратор"));
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ДокументыРегистраторы, Неопределено);
	ДатыДокументов = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(ДокументыРегистраторы, "Дата");
	
	Месяцы = Новый Массив;
	Для Каждого СтрокаСведений Из ДанныеОПремиях Цикл
		Если Месяцы.Найти(СтрокаСведений.Период) = Неопределено Тогда
			Месяцы.Добавить(СтрокаСведений.Период);
		КонецЕсли;
		НоваяСтрока = СведенияОПремиях.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаСведений);	
		НоваяСтрока.ДатаРегистратора = ДатыДокументов[СтрокаСведений.Регистратор];
	КонецЦикла;
	
	ИмяВарианта = УчетСреднегоЗаработка.ИмяПолитикиИсключенияДублирующихПремий();
	ОписаниеПолитики = УчетСреднегоЗаработка.ОписаниеПолитикиИсключенияДублирующихПремий(ИмяВарианта);
	
	СодержимоеПодсказки = Новый Массив;
	СодержимоеПодсказки.Добавить(ОписаниеПолитики.ПодробноеОписание);
	
	Элементы.ОписаниеПолитики.Заголовок = ОписаниеПолитики.Описание;
	Элементы.ОписаниеПолитики.РасширеннаяПодсказка.Заголовок = Новый ФорматированнаяСтрока(СодержимоеПодсказки);
	
	Для Каждого СтрокаНачислений Из ДанныеНачислений Цикл
		ЗаполнитьЗначенияСвойств(РасшифровкаСреднегоЗаработка.Добавить(), СтрокаНачислений);	
	КонецЦикла;
	
	ЗаполнитьАнализПремийДляВарианта(ИмяВарианта, СведенияОПремиях);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьАнализПремийДляВарианта(ИмяВарианта, СведенияОПремиях)
	
	Если ИмяВарианта = УчетСреднегоЗаработка.ИмяВариантаИсключенияПремийТиповаяПолитика()
		Или ИмяВарианта = УчетСреднегоЗаработка.ИмяВариантаИсключенияПремийБезИсключения() Тогда
		ЗаполнитьАнализПремий(СведенияОПремиях);
	КонецЕсли;
	
	// Это точка подключения расширений.
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьАнализПремий(СведенияОПремиях)
	
	ДанныеАнализа = РеквизитФормыВЗначение("АнализПремий");
	ДанныеАнализа.Строки.Очистить();
	
	ИтогоТаблица = РеквизитФормыВЗначение("Итого");
	ИтогоТаблица.Очистить();
	ИтогоТаблица.Добавить();
	
	ДанныеПремий = РеквизитФормыВЗначение("СведенияОПремиях");
	ДоработатьРазорвавшиесяЦепочки(ДанныеПремий);
	
	Для Каждого СтрокаПремии Из СведенияОПремиях Цикл
		
		Если Не ЗначениеЗаполнено(СтрокаПремии.СоставнаяЧасть) Тогда
			Продолжить;
		КонецЕсли;
		
		ИдентификаторСтроки = ИдентификаторДостижения(СтрокаПремии);
		
		Группа = ДанныеАнализа.Строки.Найти(ИдентификаторСтроки, "Идентификатор");
		
		Если Группа = Неопределено Тогда
			ОписаниеСтроки = ОписаниеСтрокиПремии();
			ОписаниеСтроки.Идентификатор = ИдентификаторСтроки;
			ОписаниеСтроки.ЗаголовокСтроки = ПредставлениеДостижения(СтрокаПремии);
			Группа = СоздатьСтрокуПремии(ДанныеАнализа, ОписаниеСтроки);
		КонецЕсли;
		
		ОписаниеСтроки = ОписаниеСтрокиПремии();
		ОписаниеСтроки.КлючНачисления = СтрокаПремии.КлючНачисления;
		
		Если СтрокаПремии.Регистратор = ВременныйРегистратор Тогда
			ОписаниеСтроки.ЗаголовокСтроки = НСтр("ru = '<Рассчитываемый документ>';
													|en = '<Calculated document>'");
		Иначе
			ОписаниеСтроки.ЗаголовокСтроки = СтрокаПремии.Регистратор;
		КонецЕсли;
		ОписаниеСтроки.СоставнаяЧасть = СтрокаПремии.СоставнаяЧасть;
		ОписаниеСтроки.ДатаНачала = СтрокаПремии.ДатаНачалаБазовогоПериода;
		СтрокаТаблицы = СоздатьСтрокуПремии(ДанныеАнализа, ОписаниеСтроки, Группа);
		
		ПостфиксКолонки = МесяцыРасчета.Получить(НачалоМесяца(СтрокаПремии.Период));
		Если ПостфиксКолонки = Неопределено Тогда
			// Для периода, указанного в данных не оказалось колонки.
			Продолжить;
		КонецЕсли;	
		
		ИмяКолонкиЗначение = "Значение" + ПостфиксКолонки;
		
		СтрокаТаблицы[ИмяКолонкиЗначение] = СтрокаПремии.Сумма;
		СтрокаТаблицы.Исключенная = СтрокаПремии.Исключенная;
		СтрокаТаблицы.ЭтоПерерасчет = СтрокаПремии.ЭтоПерерасчет;
		СтрокаТаблицы.ДатаДокумента = СтрокаПремии.ДатаРегистратора;
		
		Если СтрокаПремии.Исключенная Тогда
			Если Не СтрокаПремии.ЭтоПерерасчет Тогда
				ИтогоТаблица[0]["ВсегоИсключено"] = ИтогоТаблица[0]["ВсегоИсключено"] + 1;
				ИмяКолонки = "КоличествоИсключенных";
				СтрокаТаблицы[ИмяКолонки] = 1;
				СтрокаТаблицы.Родитель[ИмяКолонки] = СтрокаТаблицы.Родитель[ИмяКолонки] + 1;
			КонецЕсли;
		Иначе
			ИтогоТаблица[0][ИмяКолонкиЗначение] = ИтогоТаблица[0][ИмяКолонкиЗначение] + СтрокаПремии.Сумма;
			ИтогоТаблица[0]["ЗаВесьПериод"] = ИтогоТаблица[0]["ЗаВесьПериод"] + СтрокаПремии.Сумма;
			
			СтрокаТаблицы.Родитель[ИмяКолонкиЗначение] = СтрокаТаблицы.Родитель[ИмяКолонкиЗначение] + СтрокаПремии.Сумма;
		КонецЕсли;
		
	КонецЦикла;	
	
	ОтметитьНулевыеЦепочки(ДанныеАнализа, ДанныеПремий);
	
	ДанныеАнализа.Строки.Сортировать("ДатаНачала,КлючНачисления,ЭтоПерерасчет,ДатаДокумента", Истина);
	
	ЗначениеВДанныеФормы(ДанныеАнализа, АнализПремий);
	ЗначениеВДанныеФормы(ИтогоТаблица, Итого);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборПолитикиЗавершение(Результат, ДополнительныеПараметры) Экспорт 

	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат = Истина Тогда
		ПоказатьПредупреждение(,
			НСтр("ru = 'Выбрана другая политика исключения дублирующих премий.
					   |Данные анализа не актуальны, следует перечитать данные учета среднего заработка.';
					   |en = 'A different policy for eliminating duplicate bonuses has been selected.
					   |The analysis data is not relevant, re-read the average earnings accounting data.'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьИЗакрыть(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если ТолькоПросмотр Тогда
		Закрыть();
		Возврат;
	КонецЕсли;
	
	Модифицированность = Ложь;
	ОповеститьОВыборе(ДанныеПремийДляРасчетаСреднего());
	
КонецПроцедуры

&НаСервере
Функция СоздатьСтрокуПремии(Дерево, ОписаниеСтроки, Родитель = Неопределено)
	
	Если Родитель = Неопределено Тогда
		НоваяСтрока = Дерево.Строки.Добавить();
	Иначе
		НоваяСтрока = Родитель.Строки.Добавить();
	КонецЕсли;
	
	НоваяСтрока.Идентификатор	= ОписаниеСтроки.Идентификатор;
	НоваяСтрока.ЗаголовокСтроки	= ОписаниеСтроки.ЗаголовокСтроки;
	НоваяСтрока.СоставнаяЧасть	= ОписаниеСтроки.СоставнаяЧасть;
	НоваяСтрока.КлючНачисления = ОписаниеСтроки.КлючНачисления;
	НоваяСтрока.ДатаНачала = ОписаниеСтроки.ДатаНачала;
	НоваяСтрока.КоличествоИсключенных = 0;
	НоваяСтрока.ФорматЗначения	= "ЧДЦ=" + ОписаниеСтроки.Точность;
	
	Возврат НоваяСтрока;
	
КонецФункции

&НаСервере
Функция ОписаниеСтрокиПремии()
	
	ОписаниеСтроки = Новый Структура;
	ОписаниеСтроки.Вставить("Идентификатор");
	ОписаниеСтроки.Вставить("ЗаголовокСтроки");
	ОписаниеСтроки.Вставить("СоставнаяЧасть");
	ОписаниеСтроки.Вставить("КлючНачисления");
	ОписаниеСтроки.Вставить("ДатаНачала");
	ОписаниеСтроки.Вставить("Точность", 2);
	
	Возврат ОписаниеСтроки;
	
КонецФункции

&НаСервере
Функция ИдентификаторДостижения(СтрокаПремии)
	
	Данные = Новый Массив;
	Данные.Добавить(СтрокаПремии.ПоказательПремирования);
	Данные.Добавить(НачалоМесяца(СтрокаПремии.ДатаНачалаБазовогоПериода));
	Данные.Добавить(СтрокаПремии.КоличествоМесяцев);
	
	Возврат ОбщегоНазначения.КонтрольнаяСуммаСтрокой(Данные);

КонецФункции

&НаСервере
Функция ПредставлениеПоказателя(ПоказательПремирования)
	
	Результат = ?(ЗначениеЗаполнено(ПоказательПремирования),
		ПоказательПремирования,
		НСтр("ru = 'Премия (без показателя)';
			|en = 'Bonus (without indicator)'"));
		
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПредставлениеДостижения(СтрокаПремии)
	
	Если СтрокаПремии.КоличествоМесяцев = 1 Тогда
		Результат = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1, за %2';
																				|en = '%1, for %2'"),
			ПредставлениеПоказателя(СтрокаПремии.ПоказательПремирования),
			ЗарплатаКадрыКлиентСервер.ПолучитьПредставлениеМесяца(СтрокаПремии.ДатаНачалаБазовогоПериода),
			СтрокаПремии.КоличествоМесяцев);
	Иначе
		Результат = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1, за %3 мес. с %2';
																				|en = '%1, for %3 month(s) since %2'"),
			ПредставлениеПоказателя(СтрокаПремии.ПоказательПремирования),
			Формат(СтрокаПремии.ДатаНачалаБазовогоПериода, "ДЛФ=DD"),
			СтрокаПремии.КоличествоМесяцев);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура СоздатьКолонкиПремий(ДобавляемыеМесяцы = Неопределено)
	
	// Составляем массив существующих реквизитов.
	МассивИменРеквизитовФормы = Новый Массив;
	ЗарплатаКадры.ЗаполнитьМассивИменРеквизитовФормы(ЭтаФорма, МассивИменРеквизитовФормы, "АнализПремий");
	
	Если ДобавляемыеМесяцы = Неопределено Тогда
		// Выявляем добавленные месяцы.
		ДобавляемыеМесяцы = Новый Массив;
		Для Каждого КлючИЗначение Из МесяцыРасчета Цикл
			Месяц = КлючИЗначение.Ключ;
			ПостфиксКолонки = ПостфиксКолонки(Месяц);
			// Запоминаем месяцы, колонки для которых нужно добавить.
			Если МассивИменРеквизитовФормы.Найти("АнализПремий.Значение" + ПостфиксКолонки) = Неопределено Тогда
				ДобавляемыеМесяцы.Добавить(Месяц);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Создаем реквизиты по количеству месяцев.
	ДобавляемыеРеквизиты = Новый Массив;
	Для Каждого Месяц Из ДобавляемыеМесяцы Цикл
		ПостфиксКолонки = ПостфиксКолонки(Месяц);
		Если МассивИменРеквизитовФормы.Найти("АнализПремий.Значение" + ПостфиксКолонки) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		ДобавляемыеРеквизиты.Добавить(
			Новый РеквизитФормы("Значение" + ПостфиксКолонки, Новый ОписаниеТипов("Число"), "АнализПремий"));
		ДобавляемыеРеквизиты.Добавить(
			Новый РеквизитФормы("Значение" + ПостфиксКолонки, Новый ОписаниеТипов("Число"), "Итого"));	
	КонецЦикла;
	
	ИзменитьРеквизиты(ДобавляемыеРеквизиты);
	
	// Добавляем недостающие элементы формы.
	Для Каждого Месяц Из ДобавляемыеМесяцы Цикл
		// Колонки вставляются рекурсивно для того, чтобы восстановить последовательность.
		ДобавитьКолонкуПремии(Месяц);
	КонецЦикла;
	
	// Скрываем колонки, которые не используются, и наоборот показываем, которые теперь используются.
	Колонки = Элементы.ПремииЗначения.ПодчиненныеЭлементы;
	Для Каждого ПолеФормы Из Колонки Цикл
		ПостфиксКолонки = ПостфиксПоИмениЯчейки(ПолеФормы.Имя);
		Месяц = МесяцПоПостфиксу(ПостфиксКолонки);
		ПолеФормы.Видимость = МесяцыРасчета.Получить(Месяц) <> Неопределено;
	КонецЦикла;
	
	// Добавляем условное оформление для вновь добавленных колонок.
	
	ШрифтЗачеркнутый = Новый Шрифт(Элементы.АнализПремий.Шрифт,,,,,,Истина);
	
	// Поля, имеющие расшифровку, выделяются цветом.
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	// оформляемые поля
	Для Каждого Месяц Из ДобавляемыеМесяцы Цикл
		ОформляемоеПоле = ЭлементОформления.Поля.Элементы.Добавить();
		ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("ПремияЗначение" + ПостфиксКолонки(Месяц));
		ОформляемоеПоле.Использование = Истина;
	КонецЦикла;
	// условие оформления
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ЭлементОформления.Отбор, "АнализПремий.СоставнаяЧасть",, ВидСравненияКомпоновкиДанных.Заполнено);
	// параметры оформления
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПоясняющийТекст);
	
	// Исключенные премии, выделяются цветом.
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	// оформляемые поля
	Для Каждого Месяц Из ДобавляемыеМесяцы Цикл
		ОформляемоеПоле = ЭлементОформления.Поля.Элементы.Добавить();
		ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("ПремияЗначение" + ПостфиксКолонки(Месяц));
		ОформляемоеПоле.Использование = Истина;
	КонецЦикла;
	// условие оформления
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ЭлементОформления.Отбор, "АнализПремий.Исключенная", Истина);
	// параметры оформления
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Шрифт", ШрифтЗачеркнутый);
	
	Для Каждого Месяц Из ДобавляемыеМесяцы Цикл
		ПостфиксКолонки = ПостфиксКолонки(Месяц);
		
		// Добавляем формат значений в виде условного оформления.
		ЭлементОформления = УсловноеОформление.Элементы.Добавить();
		ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Формат", Новый ПолеКомпоновкиДанных("ФорматЗначения"));
		ЭлементОформления.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("ПремияЗначение" + ПостфиксКолонки);
	КонецЦикла;	
	
КонецПроцедуры

&НаСервере
Функция ДобавитьКолонкуПремии(Месяц)
	
	Если МесяцыРасчета.Получить(Месяц) = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ПостфиксКолонки = ПостфиксКолонки(Месяц);
	ИмяЭлемента = "ПремияЗначение" + ПостфиксКолонки;
	ПолеФормы = Элементы.Найти(ИмяЭлемента);
	Если ПолеФормы <> Неопределено Тогда
		Возврат ПолеФормы;
	КонецЕсли;
	
	СледующийМесяц = ДобавитьМесяц(Месяц, 1);
	ПолеСледующего = Элементы.Найти("ПремияЗначение" + ПостфиксКолонки(СледующийМесяц));
	Если ПолеСледующего = Неопределено Тогда
		ПолеСледующего = ДобавитьКолонкуПремии(СледующийМесяц);
	КонецЕсли;
	
	ПолеФормы = Элементы.Вставить(ИмяЭлемента, Тип("ПолеФормы"), Элементы.ПремииЗначения, ПолеСледующего);
	ПолеФормы.Вид = ВидПоляФормы.ПолеНадписи;
	ПолеФормы.Ширина = 10;
	ПолеФормы.МаксимальнаяШирина = 10;
	ПолеФормы.РастягиватьПоГоризонтали = Ложь;
	ПолеФормы.АвтоМаксимальнаяШирина = Ложь;
	ПолеФормы.Формат = "ЧДЦ=2";
	ПолеФормы.ПутьКДанным = "АнализПремий.Значение" + ПостфиксКолонки;
	ПолеФормы.Заголовок = ЗарплатаКадрыКлиентСервер.ПолучитьПредставлениеМесяца(Месяц);
	ПолеФормы.ОтображатьВПодвале = Истина;
	ПолеФормы.ПутьКДаннымПодвала = "Итого[0].Значение" + ПостфиксКолонки;
	
	Возврат ПолеФормы;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПостфиксПоИмениЯчейки(ИмяЯчейки)
	
	Если СтрНайти(ИмяЯчейки, "Значение") > 0 Тогда 
		Возврат СтрЗаменить(ИмяЯчейки, "ПремияЗначение", "");
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция МесяцПоПостфиксу(ПостфиксКолонки)
	Возврат Дата(Лев(ПостфиксКолонки, 4), Прав(ПостфиксКолонки, 2), 1);
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПостфиксКолонки(Месяц)
	Возврат Формат(Месяц, "ДФ=ггггММ")
КонецФункции

&НаСервере
Процедура ОтменитьИзмененияНаСервере()
	
	ДанныеОПремиях = РеквизитФормыВЗначение("СведенияОПремиях");
	ДанныеОНачислениях = РеквизитФормыВЗначение("РасшифровкаСреднегоЗаработка");
	
	ОтборПоКлючуНачисления = Новый Структура("КлючНачисления");
	
	Для Каждого СтрокаПремии Из ДанныеОПремиях Цикл
		СтрокаПремии.Исключенная = СтрокаПремии.Дублирующая;
		
		ОтборПоКлючуНачисления.КлючНачисления = СтрокаПремии.КлючНачисления;
		СтрокиНачислений = ДанныеОНачислениях.НайтиСтроки(ОтборПоКлючуНачисления);
		Для Каждого СтрокаНачисления Из СтрокиНачислений Цикл
			СтрокаНачисления.ИсключеннаяЧасть = СтрокаПремии.Исключенная;
		КонецЦикла;
	КонецЦикла;
	
	ЗаполнитьФорму(ДанныеОПремиях, ДанныеОНачислениях);
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаСервере
Функция ОтметитьИсключенные(КоллекцияЭлементов, КлючНачисления, ЗначениеФлага)
	
	ИдентификаторыСтрок = Новый Массив;

	Для Каждого СтрокаАнализа Из КоллекцияЭлементов Цикл
		ПодчиненныеСтроки = СтрокаАнализа.ПолучитьЭлементы();
		Если ПодчиненныеСтроки.Количество() > 0 Тогда
			ИдентификаторыПодчиненных = ОтметитьИсключенные(ПодчиненныеСтроки, КлючНачисления, ЗначениеФлага);
			ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ИдентификаторыСтрок, ИдентификаторыПодчиненных);
		ИначеЕсли СтрокаАнализа.КлючНачисления = КлючНачисления И СтрокаАнализа.Исключенная <> ЗначениеФлага Тогда
			ИдентификаторыСтрок.Добавить(СтрокаАнализа.ПолучитьИдентификатор());
			СтрокаАнализа.Исключенная = ЗначениеФлага;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ИдентификаторыСтрок;
	
КонецФункции
	
&НаСервере
Процедура ОтметитьИсключенныеНаСервере(ТекущийКлючНачисления, ЗначениеФлага, ИдентификаторСтроки)
	
	// Строки с одинаковым ключем начисления помечаются совместно,
	// это могут быть, например, документы выполнившие перерасчет.
	ИдентификаторыСтрок = ОтметитьИсключенные(АнализПремий.ПолучитьЭлементы(), ТекущийКлючНачисления, ЗначениеФлага);
	ИдентификаторыСтрок.Добавить(ИдентификаторСтроки);
	ПересчитатьИтоги(ИдентификаторыСтрок);

КонецПроцедуры

&НаСервере
Процедура ПересчитатьИтоги(ИдентификаторыСтрок)
	
	СтрокаИтого = Итого.Получить(0);
	
	Для Каждого ИдентификаторСтроки Из ИдентификаторыСтрок Цикл
	
		СтрокаАнализа = АнализПремий.НайтиПоИдентификатору(ИдентификаторСтроки);
		
		ПересчитываемыеКолонки = Новый Массив;
		Для Каждого Элемент Из МесяцыРасчета Цикл
			ИмяКолонки = "Значение" + Элемент.Значение;
			Если СтрокаАнализа[ИмяКолонки] <> 0 Тогда
				ПересчитываемыеКолонки.Добавить(ИмяКолонки);
			КонецЕсли;
		КонецЦикла;
		
		Знак = ?(СтрокаАнализа.Исключенная, -1, 1);
		Если Не СтрокаАнализа.ЭтоПерерасчет Тогда
			СтрокаАнализа.КоличествоИсключенных = СтрокаАнализа.КоличествоИсключенных - Знак;
			СтрокаИтого["ВсегоИсключено"] = СтрокаИтого["ВсегоИсключено"] - Знак;
		КонецЕсли;
		
		ПересчитатьРекурсивно(СтрокаАнализа.ПолучитьРодителя(), СтрокаАнализа, ПересчитываемыеКолонки, Знак);
		
		Для Каждого ИмяКолонки Из ПересчитываемыеКолонки Цикл
			СтрокаИтого[ИмяКолонки] = СтрокаИтого[ИмяКолонки] + (СтрокаАнализа[ИмяКолонки] * Знак);
			СтрокаИтого["ЗаВесьПериод"] = СтрокаИтого["ЗаВесьПериод"] + (СтрокаАнализа[ИмяКолонки] * Знак);
		КонецЦикла;
		
		ОтборПоКлючуНачисления = Новый Структура("КлючНачисления", СтрокаАнализа.КлючНачисления);
		
		СтрокиНачислений = РасшифровкаСреднегоЗаработка.НайтиСтроки(ОтборПоКлючуНачисления);
		Для Каждого Строка Из СтрокиНачислений Цикл
			Строка.ИсключеннаяЧасть = СтрокаАнализа.Исключенная;
		КонецЦикла;
		
		СтрокиПремий = СведенияОПремиях.НайтиСтроки(ОтборПоКлючуНачисления);
		Для Каждого Строка Из СтрокиПремий Цикл
			Строка.Исключенная = СтрокаАнализа.Исключенная;
		КонецЦикла;
		
	КонецЦикла;
		
КонецПроцедуры

&НаСервере
Процедура ПересчитатьРекурсивно(Родитель, Строка, ПересчитываемыеКолонки, Знак)

	Для Каждого ИмяКолонки Из ПересчитываемыеКолонки Цикл
		Родитель[ИмяКолонки] = Родитель[ИмяКолонки] + (Строка[ИмяКолонки] * Знак);
	КонецЦикла;
	
	Если Не Строка.ЭтоПерерасчет Тогда
		ИмяКолонки = "КоличествоИсключенных";
		Родитель[ИмяКолонки] = Родитель[ИмяКолонки] - Знак;
	КонецЕсли;
	
	ПредыдущийРодитель = Родитель.ПолучитьРодителя();
	Если ПредыдущийРодитель <> Неопределено Тогда
		ПересчитатьРекурсивно(ПредыдущийРодитель, Строка, ПересчитываемыеКолонки, Знак)
	КонецЕсли;
	
КонецПроцедуры

#Область ФормированиеРезультатаРаботыФормы

&НаСервере
Функция ДанныеПремийДляРасчетаСреднего()
	
	ДанныеОНачислениях = УчетСреднегоЗаработка.ПустаяТаблицаНачисленийСреднийЗаработокОбщий();
	Для Каждого Строка Из РасшифровкаСреднегоЗаработка Цикл
		ЗаполнитьЗначенияСвойств(ДанныеОНачислениях.Добавить(), Строка);
	КонецЦикла;
	
	ДанныеОПремиях = УчетСреднегоЗаработка.ПустаяТаблицаПремий();
	Для Каждого Строка Из СведенияОПремиях Цикл
		ЗаполнитьЗначенияСвойств(ДанныеОПремиях.Добавить(), Строка);
	КонецЦикла;
	
	Результат = Новый Структура;
	Результат.Вставить("Сотрудник", Сотрудник);
	Результат.Вставить("ПорядокРасчета", ПорядокРасчета);
	Результат.Вставить("РасшифровкаСреднегоЗаработка", ПоместитьВоВременноеХранилище(ДанныеОНачислениях));
	Результат.Вставить("СведенияОПремиях", ПоместитьВоВременноеХранилище(ДанныеОПремиях));
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область ИнициализацияИНастройкаФормыПриСозданииНаСервере

&НаСервере
Процедура УстановитьЗаголовокФормы()
	
	Заголовок = НСтр("ru = 'Анализ премий для учета в среднем заработке';
					|en = 'Bonus analysis for accounting in average earnings'");
	
	Если ТолькоПросмотр Тогда
		Заголовок = Заголовок + " " + НСтр("ru = '(только просмотр)';
											|en = '(Read-only)'");
	КонецЕсли;
							
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьМесяцыРасчета(Форма)
	
	СоответствиеМесяцев = Новый Соответствие;
	МесяцОбхода = Форма.НачалоПериодаРасчета;
	Пока МесяцОбхода <= Форма.ОкончаниеПериодаРасчета Цикл
		СоответствиеМесяцев.Вставить(МесяцОбхода, ПостфиксКолонки(МесяцОбхода));
		МесяцОбхода = ДобавитьМесяц(МесяцОбхода, 1);
	КонецЦикла;
	Форма.МесяцыРасчета = Новый ФиксированноеСоответствие(СоответствиеМесяцев);
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ДоработатьРазорвавшиесяЦепочки(ДанныеПремий)
	
	// Ищем разорвавшиеся цепочки, имеющие в составе только строки перерасчета.
	// Цепочка может разорваться, например, при изменении показателя премирования.
	Счетчики = Новый Соответствие();
	ДанныеПремий.Сортировать("ДатаРегистратора Возр, Сумма Возр");
	Для Каждого Строка Из ДанныеПремий Цикл
		Приращение = ?(Строка.ЭтоПерерасчет, 0, 1);
		Счетчик = Счетчики.Получить(Строка.КлючНачисления);
		Если Счетчик = Неопределено Тогда
			Счетчики.Вставить(Строка.КлючНачисления, Приращение);
		Иначе
			Счетчики.Вставить(Строка.КлючНачисления, Счетчик + Приращение);
		КонецЕсли;
	КонецЦикла;
	
	// Искусственно сбрасываем признак перерасчета, что бы у цепочки появился флаг доступный для пометки.
	Отбор = Новый Структура("КлючНачисления");
	Для Каждого Элемент Из Счетчики Цикл
		Если Элемент.Значение = 0 Тогда
			Отбор.КлючНачисления = Элемент.Ключ;
			Строки = ДанныеПремий.НайтиСтроки(Отбор);
			Если Строки.Количество() > 0 Тогда
				Строки[0].ЭтоПерерасчет = Ложь;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	ЗначениеВДанныеФормы(ДанныеПремий, СведенияОПремиях);
	
КонецПроцедуры

&НаСервере
Процедура ОтметитьНулевыеЦепочки(АнализПремий, ДанныеПремий)
	
	// Пометка нулевых цепочек, для визуального выделения.
	// Их исключение бессмысленно, но дает информацию о ходе перерасчетов.
	СуммыПоКлючам = ДанныеПремий.Скопировать(, "КлючНачисления, Сумма");
	СуммыПоКлючам.Свернуть("КлючНачисления", "Сумма");
	НулевыеСтроки = СуммыПоКлючам.НайтиСтроки(Новый Структура("Сумма", 0));
	ОтборПоКлючу = Новый Структура("КлючНачисления", 0);
	
	Для Каждого Строка Из НулевыеСтроки Цикл
		ОтборПоКлючу.КлючНачисления = Строка.КлючНачисления;
		СтрокиАнализа = АнализПремий.Строки.НайтиСтроки(ОтборПоКлючу, Истина);
		Для Каждого СтрокаАнализа Из СтрокиАнализа Цикл
			СтрокаАнализа.НулеваяЦепочка = Истина;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти