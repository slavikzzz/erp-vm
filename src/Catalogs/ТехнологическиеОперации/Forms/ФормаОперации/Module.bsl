#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	ДополнительныеПараметры.Вставить("ОтложеннаяИнициализация", Истина);
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриЧтенииСозданииНаСервере();
	
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если НЕ СинхроннаяЗагрузка Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ВремяРаботыПриСинхроннойЗагрузке");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	// Проверка реквизитов вида операции
	НомерСтроки = 1;
	
	Для каждого Строка Из ДопРеквизиты Цикл
		
		Если Строка.ЗначениеМин > Строка.ЗначениеМакс И Строка.ЗначениеМакс <> 0 Тогда
			
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Минимальное значение реквизита ""%1"" превышает максимальное значение';
											|en = 'The minimum value of the ""%1"" attribute exceeds the maximum value'"),
				Строка.Заголовок);
				
			Путь = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ДопРеквизиты", НомерСтроки, "ЗначениеМин");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, Путь,, Отказ);
			
		КонецЕсли;
		
		НомерСтроки = НомерСтроки + 1;
		
	КонецЦикла;
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	РедакторПроизводственногоПроцессаКлиентСервер.ЗагрузитьНормативыВидаОперации(ТекущийОбъект, ДопРеквизиты);
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ТехнологическиеОперации", ПараметрыЗаписи);

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ВариантыНаладки" ИЛИ ИмяСобытия = "Запись_ВидыРабочихЦентров" Тогда
		ПрочитатьРеквизитыРабочегоЦентра();
	КонецЕсли;
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	// СтандартныеПодсистемы.Свойства
	Если ТекущаяСтраница.Имя = "ГруппаДополнительныеРеквизиты"
		И Не ЭтотОбъект.ПараметрыСвойств.ВыполненаОтложеннаяИнициализация Тогда
		
		СвойстваВыполнитьОтложеннуюИнициализацию();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
		
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура УчастокПриИзменении(Элемент)
	УчастокПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура РабочийЦентрПриИзменении(Элемент)
	
	РабочийЦентрПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантНаладкиПриИзменении(Элемент)
	
	ВариантНаладкиПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантНаладкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Объект.РабочийЦентр) Тогда
		
		СтандартнаяОбработка = Ложь;
		
		РедакторПроизводственногоПроцессаКлиент.ОткрытьФормуВыбораВариантаНаладки(
			Объект.РабочийЦентр,
			Объект.ВариантНаладки,
			Элемент);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоПриИзменении(Элемент)
	
	Элементы.ЕдиницаИзмерения.ПодсказкаВвода = УправлениеПроизводствомКлиентСервер.ПредставлениеЕдиницыИзмеренияОперации(
		Объект.ЕдиницаИзмерения, Объект.Количество);
	РедакторПроизводственногоПроцессаКлиентСервер.ЗаполнитьЕдиницуИзмеренияПередаточнойПартии(
		Объект, ЕдиницаИзмеренияПередаточнойПартии);
	
КонецПроцедуры

&НаКлиенте
Процедура ЕдиницаИзмеренияПриИзменении(Элемент)
	
	РедакторПроизводственногоПроцессаКлиентСервер.ЗаполнитьЕдиницуИзмеренияПередаточнойПартии(
		Объект, ЕдиницаИзмеренияПередаточнойПартии);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередаточнаяПартияПриИзменении(Элемент)
	
	РедакторПроизводственногоПроцессаКлиентСервер.ЗаполнитьЕдиницуИзмеренияПередаточнойПартии(
		Объект, ЕдиницаИзмеренияПередаточнойПартии);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидОперацииПриИзменении(Элемент)
	
	ВидОперацииПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ВидОперацииПриИзмененииНаСервере()
	
	РедакторПроизводственногоПроцесса.ВидОперацииПриИзменении(Объект, ЭтотОбъект);
	
	НастроитьЗависимыеЭлементыФормы(ЭтотОбъект, "ВидОперации");
	
КонецПроцедуры

&НаКлиенте
Процедура МаршрутПредставлениеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "#ОткрытьМаршрут" Тогда 
		
		ПоказатьЗначение(, Маршрут);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДопРеквизиты

&НаКлиенте
Процедура ДопРеквизитыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "ДопРеквизитыЗаголовок" Тогда
		
		СтандартнаяОбработка = Ложь;
	
		ПоказатьЗначение(, Элементы.ДопРеквизиты.ТекущиеДанные.Свойство);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДопРеквизитыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	РедакторПроизводственногоПроцессаКлиент.ДопРеквизитыУстановитьФорматРедактированияНормативов(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ДопРеквизитыЗначениеМинПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
	ТекущиеДанные = Элементы.ДопРеквизиты.ТекущиеДанные;
	
	РедакторПроизводственногоПроцессаКлиент.ДопРеквизитыЗначениеНормативаПриИзменении(ТекущиеДанные, "ЗначениеМин");
	
КонецПроцедуры

&НаКлиенте
Процедура ДопРеквизитыЗначениеМаксПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
	ТекущиеДанные = Элементы.ДопРеквизиты.ТекущиеДанные;
	
	РедакторПроизводственногоПроцессаКлиент.ДопРеквизитыЗначениеНормативаПриИзменении(ТекущиеДанные, "ЗначениеМакс");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область СтандартныеПодсистемы_Свойства

&НаСервере
Процедура СвойстваВыполнитьОтложеннуюИнициализацию()
	
	УправлениеСвойствами.ЗаполнитьДополнительныеРеквизитыВФорме(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	// Инициализация служебных реквизитов.
	Если ТипЗнч(Объект.Владелец) = Тип("СправочникСсылка.ЭтапыПроизводства") Тогда
		РеквизитСтатус = "Владелец.Статус";
	Иначе
		РеквизитСтатус = "Статус";
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	НастроитьПоПодразделению();
	
	СтатусВладельца = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Владелец, РеквизитСтатус);
	ДоступностьЭлементов = РедакторПроизводственногоПроцесса.ОпределитьДоступностьЭлементовОперации(СтатусВладельца);
	
	ЗаполнитьРеквизитыМаршрутаОперации();
	
	ПараметрыПодразделения = ПроизводствоСервер.ПараметрыПроизводственногоПодразделения(Подразделение);
	
	НастройкиПодсистемы = ПроизводствоСервер.НастройкиПодсистемыПроизводство();
	ИспользуетсяПроизводство21 = НастройкиПодсистемы.ИспользуетсяПроизводство21;
	ИспользуетсяПроизводство22 = НастройкиПодсистемы.ИспользуетсяПроизводство22;
	
	ХранитьОперацииВРесурсныхСпецификациях = ПолучитьФункциональнуюОпцию("ХранитьОперацииВРесурсныхСпецификациях");
	
	РедакторПроизводственногоПроцесса.ПрочитатьРеквизитыРабочегоЦентра(Объект, ЭтотОбъект);
	РедакторПроизводственногоПроцесса.НастроитьВидимостьДоступностьЭлементовОперации(Объект, ЭтотОбъект, ПараметрыПодразделения);
	РедакторПроизводственногоПроцесса.НастроитьПараметрыВыбораРабочихЦентров(Объект, ЭтотОбъект, Подразделение);
	РедакторПроизводственногоПроцесса.НастроитьПараметрыВыбораУчасток(Объект, ЭтотОбъект, Подразделение);
	РедакторПроизводственногоПроцесса.ПрочитатьРеквизитыВидаОперации(Объект, ЭтотОбъект);
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Если Объект.СодержитВложенныйМаршрут Тогда
		// Выполняется смена вида операции
		Объект.СодержитВложенныйМаршрут = Ложь;
		Объект.РабочийЦентр = Неопределено;
		Объект.Участок = Неопределено;
		Объект.ВариантНаладки = Неопределено;
		Объект.ВидОперации = Неопределено;
		Объект.ВремяШтучное = 0;
		Объект.ВремяПЗ = 0;
		Объект.Загрузка = 0;
		Объект.Непрерывная = Ложь;
		Объект.МожноПовторить = Ложь;
		Объект.МожноПропустить = Ложь;
		Объект.ВспомогательныеРабочиеЦентры.Очистить();
		Объект.НормативыВидаОперации.Очистить();
		Модифицированность = Истина;
	КонецЕсли;
	
	Элементы.Участок.ПодсказкаВвода = РедакторПроизводственногоПроцесса.ПредставлениеУчастка(Объект, Элементы.Участок.Видимость);
	
	Элементы.ЕдиницаИзмерения.ПодсказкаВвода = УправлениеПроизводствомКлиентСервер.ПредставлениеЕдиницыИзмеренияОперации(
		Объект.ЕдиницаИзмерения, Объект.Количество);
	РедакторПроизводственногоПроцессаКлиентСервер.ЗаполнитьЕдиницуИзмеренияПередаточнойПартии(
		Объект, ЕдиницаИзмеренияПередаточнойПартии);
	
	ВидОперации = Объект.ВидОперации;
	
	НастроитьЗависимыеЭлементыФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура РабочийЦентрПриИзмененииНаСервере()
	
	РедакторПроизводственногоПроцесса.РабочийЦентрПриИзменении(Объект, ЭтотОбъект);
	
	Элементы.Участок.ПодсказкаВвода = РедакторПроизводственногоПроцесса.ПредставлениеУчастка(Объект, Элементы.Участок.Видимость);
	
КонецПроцедуры

&НаСервере
Процедура УчастокПриИзмененииНаСервере()
	
	РедакторПроизводственногоПроцесса.УчастокПриИзменении(Объект, ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьПоПодразделению()
	
	Подразделение = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Владелец, "Подразделение");
	
	Если ЗначениеЗаполнено(Подразделение) Тогда
		УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Подразделение", Подразделение));
	Иначе
		УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Подразделение", Неопределено));
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВариантНаладкиПриИзмененииНаСервере()
	
	РедакторПроизводственногоПроцесса.ВариантНаладкиПриИзменении(Объект, ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьРеквизитыРабочегоЦентра()
	
	РедакторПроизводственногоПроцесса.ПрочитатьРеквизитыРабочегоЦентра(Объект, ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыМаршрутаОперации()
	
	РеквизитыМаршрута = Справочники.ТехнологическиеОперации.РеквизитыМаршрутаОперации(Объект.Владелец);
	
	Маршрут              = РеквизитыМаршрута.Маршрут;
	МаршрутПредставление = Новый ФорматированнаяСтрока(
		РеквизитыМаршрута.МаршрутПредставление,,,,
		?(РеквизитыМаршрута.МаршрутДоступен, "#ОткрытьМаршрут", ""));
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьЗависимыеЭлементыФормы(Форма, СписокРеквизитов = "")
	
	Объект = Форма.Объект;
	Элементы = Форма.Элементы;
	
	Инициализация = ПустаяСтрока(СписокРеквизитов);
	СтруктураРеквизитов = Новый Структура(СписокРеквизитов);
	
	Если СтруктураРеквизитов.Свойство("ВидОперации")
		ИЛИ Инициализация Тогда
			
			Элементы.СтраницаКонтролируемыеПараметры.Видимость = ЗначениеЗаполнено(Объект.ВидОперации);
			
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
