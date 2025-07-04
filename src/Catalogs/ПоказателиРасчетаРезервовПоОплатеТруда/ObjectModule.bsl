#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	// Проверяем допустимость идентификатора.
	
	// - В строке не должно быть разделителей.
	ЕстьРазделители = Ложь;
	Для Позиция = 1 По СтрДлина(Идентификатор) Цикл
		Если СтроковыеФункцииКлиентСервер.ЭтоРазделительСлов(КодСимвола(Идентификатор, Позиция)) Тогда
			ОбщегоНазначения.СообщитьПользователю(
				НСтр("ru = 'Идентификатор содержит недопустимые символы';
					|en = 'ID contains invalid characters'"), , "Объект.Идентификатор", , Отказ);
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	// - Строка не должна начинаться с числа.
	КодПервогоСимвола = КодСимвола(Идентификатор, 1);
	Если КодПервогоСимвола >= 48 И КодПервогоСимвола <= 57 Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Идентификатор не может начинаться с цифры';
				|en = 'ID cannot start with a digit'"), , "Объект.Идентификатор", , Отказ);
	КонецЕсли;
	
	// Проверяем, нет ли показателя с таким идентификатором.
	ПоказательПоИдентификатору = ЗарплатаКадрыРасширенный.ПоказательПоИдентификатору(Идентификатор);
	Если ПоказательПоИдентификатору <> Неопределено 
		И ПоказательПоИдентификатору <> Ссылка Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Показатель с идентификатором %1 уже существует.';
				|en = 'Indicator with ID %1 already exists.'"), Идентификатор);
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , "Объект.Идентификатор", , Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;		
	
	ИдентификаторСлужебный = ВРег(Идентификатор);
	
	СтарыеЗначения = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, "Идентификатор");
	// Проверка изменения идентификатора.
	Если ЗначениеЗаполнено(Ссылка) Тогда 
		ДополнительныеСвойства.Вставить("ПрежнийИдентификатор", СтарыеЗначения.Идентификатор);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;		
	
	// Проверка изменения идентификатора.
	ПрежнийИдентификатор = Неопределено;
	Если ДополнительныеСвойства.Свойство("ПрежнийИдентификатор", ПрежнийИдентификатор) И Идентификатор <> ПрежнийИдентификатор Тогда 
		ДополнительныеСвойства.Вставить("ВыполнитьОбновлениеВидовРасчета", Истина);
		ДополнительныеСвойства.Вставить("ИдентификаторИзменен", Истина);
		ОбновитьПовторноИспользуемыеЗначения();
	КонецЕсли;	
	
	ВыполнитьОбновлениеВидовРасчета();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ВыполнитьОбновлениеВидовРасчета()
	
	Если Не ДополнительныеСвойства.Свойство("ВыполнитьОбновлениеВидовРасчета") Тогда 
		Возврат;
	КонецЕсли;
	
	ЗаполнитьИнформациюОПоказателях = ДополнительныеСвойства.Свойство("ЗаполнитьИнформациюОПоказателях");
	ИдентификаторИзменен 			= ДополнительныеСвойства.Свойство("ИдентификаторИзменен");
	ШкалаОценкиИзменена 			= ДополнительныеСвойства.Свойство("ШкалаОценкиИзменена");
	
	ВидыРасчетаМассив = Новый Массив;
	
	// Обновить вторичные данные в тех видах расчета, которые зависят от показателя.
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	НачисленияПоказатели.Ссылка КАК ВидРасчета,
	|	НачисленияПоказатели.Ссылка.Наименование КАК Наименование,
	|	НачисленияПоказатели.Ссылка.ФормулаРасчета КАК ФормулаРасчета
	|ИЗ
	|	Справочник.ВидыРасчетовРезервовПоОплатеТруда.Показатели КАК НачисленияПоказатели
	|ГДЕ
	|	НачисленияПоказатели.Показатель = &Показатель");
	
	Запрос.УстановитьПараметр("Показатель", Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ВидРасчета = Выборка.ВидРасчета.ПолучитьОбъект();
		
		Если ЗаполнитьИнформациюОПоказателях Тогда
			РезервыПоОплатеТрудаРасширенный.ЗаполнитьИнформациюОПоказателяхВидаРасчета(ВидРасчета);
		КонецЕсли;
			
		Если ИдентификаторИзменен Тогда
			ПрежнийИдентификатор = ДополнительныеСвойства.ПрежнийИдентификатор;
			НоваяФормулаРасчета = РасчетЗарплатыРасширенный.ЗаменитьЗначениеИдентификатораВФормулеРасчета(Идентификатор, ПрежнийИдентификатор, Выборка.ФормулаРасчета);
			ВидРасчета.ФормулаРасчета = НоваяФормулаРасчета;
		КонецЕсли;
		
		ВидыРасчетаМассив.Добавить(ВидРасчета);
		
	КонецЦикла;
	
	ЗаписатьПакетВидовРасчета(ВидыРасчетаМассив);
	
КонецПроцедуры

Процедура ЗаписатьПакетВидовРасчета(ВидыРасчета)
	
	Если ВидыРасчета.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ВидРасчета Из ВидыРасчета Цикл
		Попытка
			ВидРасчета.Заблокировать();
		Исключение
			ТекстИсключенияЗаписи = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Требуется внести изменение в вид расчета резервов «%1». 
				|В данный момент изменение невозможно, так как вид расчета резервов редактируется другим пользователем или в другой форме программы';
				|en = 'Make changes to payroll fund calculation type ""%1"".
				|Cannot change at this moment, as the payroll fund calculation type is being edited by another user or in another application form'"),
				ВидРасчета.Наименование);
			ВызватьИсключение ТекстИсключенияЗаписи;
		КонецПопытки;
		ВидРасчета.ОбменДанными.Загрузка = Истина;
		ВидРасчета.Записать();
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли