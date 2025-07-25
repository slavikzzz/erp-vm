#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	НоваяЗапись = Параметры.Ключ.Пустой();
	
	Если НоваяЗапись Тогда
		Запись.Пользователь = Параметры.Пользователь;
		Запись.ОткрываемаяФорма = Параметры.ОткрываемаяФорма;
		
		РежимОткрытия = "ЧерезПараметр";
		
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
	УстановитьТипИсполнителя();
	
КонецПроцедуры

// Параметры:
// 	ТекущийОбъект - РегистрСведенийМенеджерЗаписи.НастройкиОткрытияФормПриНачалеРаботыСистемы - 
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	РежимОткрытия = ?(ТекущийОбъект.ОткрыватьПоУмолчанию,"ПоУмолчанию","ЧерезПараметр");
	
	СтруктураПараметров = ТекущийОбъект.Параметры.Получить();
	
	Если ТипЗнч(СтруктураПараметров) = Тип("Структура") Тогда
		
		Подразделение = ?(СтруктураПараметров.Свойство("Подразделение"), СтруктураПараметров.Подразделение, Неопределено);
		Участок       = ?(СтруктураПараметров.Свойство("Участок"), СтруктураПараметров.Участок, Неопределено);
		РежимРаботы   = ?(СтруктураПараметров.Свойство("РежимРаботы"), СтруктураПараметров.РежимРаботы, Неопределено);
		РабочийЦентр  = ?(СтруктураПараметров.Свойство("РабочийЦентр"), СтруктураПараметров.РабочийЦентр, Неопределено);
		Исполнитель   = ?(СтруктураПараметров.Свойство("Исполнитель"), СтруктураПараметров.Исполнитель, Неопределено);
		
		МожноИзменятьПодразделение = ?(СтруктураПараметров.Свойство("МожноИзменятьПодразделение"),
										СтруктураПараметров.МожноИзменятьПодразделение,
										Ложь);
		
		Элементы.МожноИзменятьПодразделение.Доступность = НЕ ЗначениеЗаполнено(РабочийЦентр);
		
	КонецЕсли;
	
	ИзменитьДоступностьУчастка();
	
	ПриЧтенииСозданииНаСервере();
	
КонецПроцедуры

// Параметры:
// 	Отказ - Булево - 
// 	ТекущийОбъект - РегистрСведенийМенеджерЗаписи.НастройкиОткрытияФормПриНачалеРаботыСистемы - 
// 	ПараметрыЗаписи - Структура - 
&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Подразделение", Подразделение);
	СтруктураПараметров.Вставить("Участок", Участок);
	СтруктураПараметров.Вставить("РежимРаботы", РежимРаботы);
	СтруктураПараметров.Вставить("РабочийЦентр", РабочийЦентр);
	СтруктураПараметров.Вставить("Исполнитель", Исполнитель);
	СтруктураПараметров.Вставить("МожноИзменятьПодразделение", МожноИзменятьПодразделение);
	
	ТекущийОбъект.Параметры = Новый ХранилищеЗначения(СтруктураПараметров);
	ТекущийОбъект.ТекстовоеПредставлениеПараметров = 
		ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Подразделение, "Наименование")
		+ ?(Участок.Пустая(),"", " / " + ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Участок, "Наименование"));
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	СтруктураИзмерений = Новый Структура;
	СтруктураИзмерений.Вставить("Пользователь", Запись.Пользователь);
	СтруктураИзмерений.Вставить("ОткрываемаяФорма", Запись.ОткрываемаяФорма);
	
	Оповестить("Запись_НастройкиОткрытияФормПриНачалеРаботыСистемы", ПараметрыЗаписи, СтруктураИзмерений);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	
	ИзменитьДоступностьУчастка();
	
	УстановитьТипИсполнителя();
	
КонецПроцедуры

&НаКлиенте
Процедура РежимОткрытияПриИзменении(Элемент)
	Запись.ОткрыватьПоУмолчанию = РежимОткрытия = "ПоУмолчанию";
КонецПроцедуры

&НаКлиенте
Процедура РабочийЦентрПриИзменении(Элемент)
	
	Элементы.МожноИзменятьПодразделение.Доступность = НЕ ЗначениеЗаполнено(РабочийЦентр);
	
	Если ЗначениеЗаполнено(РабочийЦентр) Тогда
		МожноИзменятьПодразделение = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ИсполнительНачалоВыбораЗавершение", ЭтотОбъект);
	
	ПроизводствоКлиент.ОткрытьФормуВыбораИсполнителя(
		Неопределено,
		Подразделение,
		Исполнитель,
		Неопределено,
		,
		ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	СтруктураПараметровФормы = ОткрытиеФормПриНачалеРаботыСистемыКлиентСерверПереопределяемый.НастройкиФормы(Запись.ОткрываемаяФорма);
	ПараметрЗапуска = СтруктураПараметровФормы.ПараметрЗапуска;
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьДоступностьУчастка()
	
	ИспользоватьУчастки = ПолучитьФункциональнуюОпцию(
		"ИспользоватьПроизводственныеУчастки",
		Новый Структура("Подразделение", Подразделение));
	
	Элементы.Участок.Доступность = ИспользоватьУчастки;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТипИсполнителя()
	
	Если Подразделение.Пустая() Тогда
		Элементы.Исполнитель.Доступность = Ложь;
		Возврат;
	Иначе
		Элементы.Исполнитель.Доступность = Истина;
	КонецЕсли;
	
	Настройки = ПроизводствоСервер.ПараметрыПроизводственногоПодразделения(Подразделение);
	
	УправлениеПроизводствомКлиентСервер.УстановитьТипИсполнителя(Исполнитель,
		Настройки.ИспользоватьБригадныеНаряды,
		ПроизводствоСервер.ИспользуетсяУчетТрудозатратВРазрезеСотрудников(ТекущаяДатаСеанса()));
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительНачалоВыбораЗавершение(Результат, Параметры) Экспорт
	
	Если ЗначениеЗаполнено(Результат) Тогда
		
		Исполнитель = Результат;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
