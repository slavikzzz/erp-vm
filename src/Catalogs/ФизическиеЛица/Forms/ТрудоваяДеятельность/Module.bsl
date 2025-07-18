
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДоступноИзменениеДанныхФизическихЛицЗарплатаКадрыРасширенная = ПольЗователи.РолиДоступны("ДобавлениеИзменениеДанныхФизическихЛицЗарплатаКадрыРасширенная");
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры, "Заголовок,ФизическоеЛицоСсылка,ИзФормыСотрудника");
	
	СотрудникиФормы.ПрочитатьДанныеИзХранилищаВФорму(
		ЭтотОбъект,
		СотрудникиКлиентСервер.ОписаниеДополнительнойФормы(ИмяФормы),
		Параметры.АдресВХранилище);
	
	СтажиСУправляемымРостом.ЗагрузитьЗначения(КадровыйУчетРасширенный.СтажиСУправляемымРостом());
	ПроинициализироватьФорму();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СотрудникиКлиент.ЗарегистрироватьОткрытиеФормы(ЭтотОбъект, ИмяФормы);
	СотрудникиКлиент.ПроверитьРежимТолькоПросмотраДополнительнойФормы(ЭтотОбъект, ИзФормыСотрудника);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ТрудоваяДеятельностьФизическихЛицРассчитатьСтажиПоТрудовойДеятельности",
		"Доступность",
		Не ТолькоПросмотр);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("СохранитьИЗакрыть", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы, ТекстПредупреждения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	СотрудникиКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
	Если ИмяСобытия = "РедактированиеПроцентаСевернойНадбавки" 
		И ФизическоеЛицоСсылка = Источник Тогда
		
		ФизическоеЛицоПроцентСевернойНадбавкиОбработкаОповещения(ИмяСобытия, Параметр, Источник);
		
	КонецЕсли;
	
	Если ИмяСобытия = "ИзмененСтажФизическогоЛица" И Источник.ВладелецФормы = ЭтотОбъект Тогда
		ОбработатьИзменениеСтажаФизическогоЛица(Параметр.ДанныеСтажей);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НадписьПроцентСевернойНадбавкиНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ПроцентыСевернойНадбавкиИзменить();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСведенияОСтажах

&НаКлиенте
Процедура СведенияОСтажахВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "СведенияОСтажахПредставлениеСтажа" Тогда
		
		Если Не ЗаблокироватьОбъектВФормеВладельце() Тогда
			Возврат;
		КонецЕсли;
		
		ДатаСведений = ОбщегоНазначенияКлиент.ДатаСеанса();
		
		ТекущиеДанные = Элемент.ТекущиеДанные;
		ВидыСтажа = Новый ФиксированныйМассив(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ТекущиеДанные.ВидСтажа));
		
		КадровыйУчетРасширенныйКлиент.ОткрытьФормуРедактированияСтажейФизическогоЛица(
			ЭтотОбъект, ФизическоеЛицоСсылка, ДатаСведений, ВидыСтажа, СтажиФизическихЛиц, Заголовок);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СведенияОСтажахПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
	Если Не ЗаблокироватьОбъектВФормеВладельце() Тогда
		Возврат;
	КонецЕсли;
	
	ОчиститьСведенияОСтаже();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТрудоваяДеятельностьФизическихЛиц

&НаКлиенте
Процедура ТрудоваяДеятельностьФизическихЛицПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Не ЗаблокироватьОбъектВФормеВладельце() Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТрудоваяДеятельностьФизическихЛицПередНачаломИзменения(Элемент, Отказ)
	
	Если Не ЗаблокироватьОбъектВФормеВладельце() Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТрудоваяДеятельностьФизическихЛицПередУдалением(Элемент, Отказ)
	
	Если Не ЗаблокироватьОбъектВФормеВладельце() Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТрудоваяДеятельностьФизическихЛицПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		
		ТекущиеДанные = Элементы.ТрудоваяДеятельностьФизическихЛиц.ТекущиеДанные;
		ПроинициализироватьНовуюСтрокуТрудовойДеятельности(ТекущиеДанные, ФизическоеЛицоСсылка);
		
		Если ТрудоваяДеятельностьФизическихЛиц.Количество() > 1 Тогда
			
			ДанныеПредыдущейСтроки = ТрудоваяДеятельностьФизическихЛиц[ТрудоваяДеятельностьФизическихЛиц.Количество() - 2];
			Если Не ЗначениеЗаполнено(ДанныеПредыдущейСтроки.ДатаОкончания) Тогда
				
				ДатаОкончания = НачалоДня(НачалоДня(ОбщегоНазначенияКлиент.ДатаСеанса()) - 1);
				Если ДатаОкончания < ДанныеПредыдущейСтроки.ДатаНачала Тогда
					ДанныеПредыдущейСтроки.ДатаОкончания = ДанныеПредыдущейСтроки.ДатаНачала;
				Иначе
					ДанныеПредыдущейСтроки.ДатаОкончания = ДатаОкончания;
				КонецЕсли;
				
			КонецЕсли;
			
			ТекущиеДанные.ДатаНачала = КонецДня(ДанныеПредыдущейСтроки.ДатаОкончания) + 1;
			
		Иначе
			ТекущиеДанные.ДатаНачала = ОбщегоНазначенияКлиент.ДатаСеанса();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТрудоваяДеятельностьФизическихЛицПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	
	Если Не ОтменаРедактирования
		И ЗначениеЗаполнено(Элементы.ТрудоваяДеятельностьФизическихЛиц.ТекущиеДанные.ДатаНачала)
		И Элементы.ТрудоваяДеятельностьФизическихЛиц.ТекущиеДанные.ДатаНачала < ЗарплатаКадрыКлиентСервер.ДатаОтсчетаПериодическихСведений() Тогда
		
		ОчиститьСообщения();
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Укажите правильную дату начала периода работы';
				|en = 'Indicate the correct start date of the work period'"), , , "ТрудоваяДеятельностьФизическихЛиц.ДатаНачала", Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТрудоваяДеятельностьФизическихЛицПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	УпорядочитьЗаписиТрудовойДеятельности(ТрудоваяДеятельностьФизическихЛиц);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНаградыФизическихЛиц

&НаКлиенте
Процедура НаградыФизическихЛицПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Не ЗаблокироватьОбъектВФормеВладельце() Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаградыФизическихЛицПередНачаломИзменения(Элемент, Отказ)
	
	Если Не ЗаблокироватьОбъектВФормеВладельце() Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаградыФизическихЛицПередУдалением(Элемент, Отказ)
	
	Если Не ЗаблокироватьОбъектВФормеВладельце() Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаградыФизическихЛицПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		Элемент.ТекущиеДанные.ФизическоеЛицо = ФизическоеЛицоСсылка;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Ок(Команда)
	
	СохранитьИЗакрытьНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьСтажиПоТрудовойДеятельности(Команда)
	
	Если ЗаблокироватьОбъектВФормеВладельце() Тогда
		
		ПараметрыОткрытия = ПараметрыОткрытияФормыРасчетаСтажа();
		
		Оповещение = Новый ОписаниеОповещения("РассчитатьСтажиПоТрудовойДеятельностиЗавершение", ЭтотОбъект);
		ОткрытьФорму("Обработка.РасчетСтажаПоТрудовойДеятельности.Форма", ПараметрыОткрытия, ЭтаФорма, Истина, , , Оповещение);
		
	Иначе
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ТрудоваяДеятельностьФизическихЛицРассчитатьСтажиПоТрудовойДеятельности",
			"Доступность",
			Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИмпортСТДР(Команда)
	
	Если ВладелецФормы.Модифицированность Тогда
		
		Если ИзФормыСотрудника Тогда
			ТекстПредупреждения = НСтр("ru = 'Перед импортом сведений необходимо сохранить данные сотрудника.';
										|en = 'Save the employee data before importing information.'");
		Иначе
			ТекстПредупреждения = НСтр("ru = 'Перед импортом сведений необходимо сохранить данные физического лица.';
										|en = 'Save the individual data before importing information.'");
		КонецЕсли;
		
		ПоказатьПредупреждение(, ТекстПредупреждения);
		
		Возврат;
		
	КонецЕсли;
	
	ПараметрыЗагрузки = ФайловаяСистемаКлиент.ПараметрыЗагрузкиФайла();
	ПараметрыЗагрузки.ИдентификаторФормы = УникальныйИдентификатор;
	ПараметрыЗагрузки.Диалог.Заголовок = НСтр("ru = 'Выберите файл СТД-Р или СТД-ПФР';
												|en = 'Select s STD-R or STD-PF file'");
	ПараметрыЗагрузки.Диалог.Фильтр = НСтр("ru = 'Файлы XML (*.xml)|*.xml';
											|en = 'Files XML (*.xml)|*.xml'");
	
	Оповещение = Новый ОписаниеОповещения("ИмпортСТДРЗавершение", ЭтотОбъект);
	ФайловаяСистемаКлиент.ЗагрузитьФайл(Оповещение, ПараметрыЗагрузки);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПроинициализироватьФорму()
	
	СведенияОНакопленныхСтажах = Новый ФиксированноеСоответствие(КадровыйУчетРасширенныйВызовСервера.СведенияОСтажахФизическогоЛица(ФизическоеЛицоСсылка, ТекущаяДатаСеанса()));
	
	Если НЕ СтажиФизическихЛицПрочитан Тогда
		СотрудникиФормы.ПрочитатьНаборЗаписей(ЭтотОбъект, "СтажиФизическихЛиц");
		СтажиФизическихЛицПрочитан = Истина;
	КонецЕсли;
	
	ЗаполнитьДанныеОСтаже();
	
	Если НЕ НаградыФизическихЛицПрочитан Тогда
		СотрудникиФормы.ПрочитатьНаборЗаписей(ЭтотОбъект, "НаградыФизическихЛиц");
		НаградыФизическихЛицПрочитан = Истина;
	КонецЕсли; 
	
	Если НЕ ТрудоваяДеятельностьФизическихЛицПрочитан Тогда
		
		СотрудникиФормы.ПрочитатьНаборЗаписей(ЭтотОбъект, "ТрудоваяДеятельностьФизическихЛиц");
		
		УстановитьПривилегированныйРежим(Истина);
		СотрудникиФормы.ПрочитатьНаборЗаписей(ЭтотОбъект, "ВидыСтажаТрудовойДеятельностиФизическихЛиц");
		УстановитьПривилегированныйРежим(Ложь);
		
		ТрудоваяДеятельностьФизическихЛицПрочитан = Истина;
		
	КонецЕсли;
	
	Если Пользователи.РолиДоступны("ДобавлениеИзменениеДанныхДляНачисленияЗарплатыРасширенная,ЧтениеДанныхДляНачисленияЗарплатыРасширенная") Тогда
		
		УстановитьПредставлениеПроцентаСевернойНадбавки();
		
	Иначе
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"НадписьПроцентСевернойНадбавки",
			"ГиперСсылка",
			Ложь);
			
	КонецЕсли;
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЗакрытыйДокумент);
	
	ОформляемоеПоле = ЭлементУсловногоОформления.Поля.Элементы.Добавить(); 
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("СведенияОСтажах");
	
	ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	ЭлементОтбора.Использование = Истина;
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СведенияОСтажах.ДатаОтсчета");
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПоясняющийОшибкуТекст);
	
	ОформляемоеПоле = ЭлементУсловногоОформления.Поля.Элементы.Добавить(); 
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("СведенияОСтажах");
	
	ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	ЭлементОтбора.Использование = Истина;
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СведенияОСтажах.ДатаОтсчета");
	
	ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Меньше;
	ЭлементОтбора.Использование = Истина;
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СведенияОСтажах.ДатаОтсчета");
	ЭлементОтбора.ПравоеЗначение = ЗарплатаКадрыКлиентСервер.ДатаОтсчетаПериодическихСведений();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеОСтаже()
	
	Если СведенияОСтажах.Количество() = 0 Тогда
		
		Запрос = Новый Запрос;
		
		Запрос.Текст =
			"ВЫБРАТЬ
			|	ВидыСтажа.Ссылка КАК ВидСтажа
			|ИЗ
			|	Справочник.ВидыСтажа КАК ВидыСтажа
			|
			|УПОРЯДОЧИТЬ ПО
			|	ВидыСтажа.Наименование";
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			НоваяСтрока = СведенияОСтажах.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		КонецЦикла;
		
	КонецЕсли;
	
	СтажиФизическихЛицВСведенияОСтажах();
	
КонецПроцедуры

&НаСервере
Процедура СтажиФизическихЛицВСведенияОСтажах()
	
	ТребуетЗаписи = Ложь;
	Для каждого СтрокаСтажа Из СведенияОСтажах Цикл
		
		НайденныеСтроки = СтажиФизическихЛиц.НайтиСтроки(Новый Структура("ВидСтажа", СтрокаСтажа.ВидСтажа));
		Если НайденныеСтроки.Количество() <> 0 Тогда
			
			СведенияОСтаже = СведенияОНакопленныхСтажах.Получить(СтрокаСтажа.ВидСтажа);
			Если СведенияОСтаже <> Неопределено И Не СведенияОСтаже.Прерван Тогда
				
				ТекущиеСведения = Новый Соответствие(СведенияОНакопленныхСтажах);
				ТекущиеСведения.Удалить(СтрокаСтажа.ВидСтажа);
				СведенияОНакопленныхСтажах = Новый ФиксированноеСоответствие(ТекущиеСведения);
				
			КонецЕсли;
			
			ДанныеСтажа = Неопределено;
			Для каждого НайденнаяСтрока Из НайденныеСтроки Цикл
				
				Если ДанныеСтажа = Неопределено
					Или ДанныеСтажа.Период < НайденнаяСтрока.Период Тогда
					
					ДанныеСтажа = НайденнаяСтрока;
					
				КонецЕсли;
				
			КонецЦикла;
			
			ЗаполнитьЗначенияСвойств(СтрокаСтажа, ДанныеСтажа);
			СтрокаСтажа.Лет = Цел(ДанныеСтажа.РазмерМесяцев / 12);
			СтрокаСтажа.Месяцев = ДанныеСтажа.РазмерМесяцев - СтрокаСтажа.Лет * 12;
			СтрокаСтажа.Дней = ДанныеСтажа.РазмерДней;
			
			Если СтрокаСтажа.ТребуетЗаписи Тогда
				ТребуетЗаписи = Истина;
				СтрокаСтажа.СостояниеРасчета = 1;
			ИначеЕсли СтрокаСтажа.Прерван Тогда
				СтрокаСтажа.СостояниеРасчета = 2;
			Иначе
				СтрокаСтажа.СостояниеРасчета = 0;
			КонецЕсли;
			
		Иначе
			СтрокаСтажа.ДатаОтсчета = '00010101';
			СтрокаСтажа.Лет = 0;
			СтрокаСтажа.Месяцев = 0;
			СтрокаСтажа.Дней = 0;
			СтрокаСтажа.СостояниеРасчета = 0;
		КонецЕсли;
		
		СформироватьПредставлениеСтажа(СтрокаСтажа, СведенияОНакопленныхСтажах, ТекущаяДатаСеанса());
		
	КонецЦикла;
	
	Если ТребуетЗаписи Тогда
		
		ТекстПодсказки =
			Новый ФорматированнаяСтрока(
				БиблиотекаКартинок.Предупреждение,
				" ",
				НСтр("ru = 'В сведениях о стаже не учтены кадровые переводы. Информация обновится после записи карточки сотрудника.';
					|en = 'Employee transfers are not recorded in the information on the length of service. The information will be updated after the employee card is saved.'"));
		
	Иначе
		ТекстПодсказки = "";
	КонецЕсли;
	
	ЗарплатаКадрыКлиентСервер.УстановитьРасширеннуюПодсказкуЭлементуФормы(
		ЭтотОбъект, "СведенияОСтажах",
		ТекстПодсказки);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СтажиНеЗаданыГруппа", "Видимость", Не СтажиЗаданы(ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьИзменениеСтажаФизическогоЛица(ДанныеСтажей, УстанавливатьМодифицированность = Истина)
	
	ТекущиеДанные = Элементы.СведенияОСтажах.ТекущиеДанные;
	Если УстанавливатьМодифицированность И ТекущиеДанные <> Неопределено Тогда
		
		ВидСтажа = ТекущиеДанные.ВидСтажа;
		СтарыеСтроки = СтажиФизическихЛиц.НайтиСтроки(Новый Структура("ВидСтажа", ВидСтажа));
		Для Каждого УдаляемаяСтрока Из СтарыеСтроки Цикл
			СтажиФизическихЛиц.Удалить(УдаляемаяСтрока);
		КонецЦикла;
		
	Иначе
		ВидСтажа = Неопределено;
		СтажиФизическихЛиц.Очистить();
	КонецЕсли;
	
	Для каждого СтрокаДанныеСтажей Из ДанныеСтажей Цикл
		
		Если ВидСтажа <> Неопределено
			И СтрокаДанныеСтажей.ВидСтажа <> ВидСтажа Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		НоваяСтрокаСтажиФизическихЛиц = СтажиФизическихЛиц.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаСтажиФизическихЛиц, СтрокаДанныеСтажей);
		НоваяСтрокаСтажиФизическихЛиц.Период = СтрокаДанныеСтажей.Период;
		
		Если ВидСтажа <> Неопределено И СтажиСУправляемымРостом.НайтиПоЗначению(ВидСтажа) <> Неопределено Тогда
			НоваяСтрокаСтажиФизическихЛиц.ТребуетЗаписи = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	СтажиФизическихЛицВСведенияОСтажах();
	
	Если УстанавливатьМодифицированность Тогда
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура СформироватьПредставлениеСтажа(ДанныеСтажа, СведенияОНакопленныхСтажах, ДатаАктуальности)
	
	ПредставлениеСтажа = "";
	Если Не ЗначениеЗаполнено(ДанныеСтажа.ДатаОтсчета) Тогда
		ПредставлениеСтажа = НСтр("ru = 'Нажмите, чтобы заполнить';
									|en = 'Click to fill in'");
	КонецЕсли;
	
	Если ПредставлениеСтажа = "" Тогда 
		
		СведенияНакопленныхСтажей = СведенияОНакопленныхСтажах.Получить(ДанныеСтажа.ВидСтажа);
		Если СведенияНакопленныхСтажей <> Неопределено Тогда
			
			СведенияОСтаже = ОбщегоНазначенияКлиентСервер.СкопироватьСтруктуру(СведенияНакопленныхСтажей);
			СведенияОСтаже.ДатаОтсчета = СведенияОСтаже.ПериодРегистрации;
			
		Иначе
			
			СведенияОСтаже = ЗарплатаКадрыРасширенныйКлиентСервер.СведенияОСтаже();
			СведенияОСтаже.ДатаОтсчета = ДанныеСтажа.ДатаОтсчета;
			СведенияОСтаже.Лет = ДанныеСтажа.Лет;
			СведенияОСтаже.Месяцев = ДанныеСтажа.Месяцев;
			СведенияОСтаже.Дней = ДанныеСтажа.Дней;
			СведенияОСтаже.ИсчисляетсяСДатыПриема = ДанныеСтажа.ИсчисляетсяСДатыПриема;
			СведенияОСтаже.Прерван = ДанныеСтажа.Прерван;
			
		КонецЕсли;
		
		Если СведенияОСтаже.ДатаОтсчета < ЗарплатаКадрыКлиентСервер.ДатаОтсчетаПериодическихСведений() Тогда
			ПредставлениеСтажа = НСтр("ru = 'Слишком маленькая дата отсчета';
										|en = 'Cycle start date is too small'");
		Иначе
			
			ДатаСведенийСтажа = ?(ДатаАктуальности < СведенияОСтаже.ДатаОтсчета, СведенияОСтаже.ДатаОтсчета, ДатаАктуальности);
			ПродолжительностьСтажа = ЗарплатаКадрыРасширенныйКлиентСервер.ПродолжительностьСтажа(СведенияОСтаже, ДатаСведенийСтажа);
			
			Если ДанныеСтажа.Прерван Тогда
				
				ПредставлениеСтажа = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'На %1 составил %2';
						|en = 'It is %2 on %1 '"), 
					Формат(ДатаСведенийСтажа, "ДЛФ=Д"),
					ЗарплатаКадрыРасширенныйКлиентСервер.ПредставлениеСтажа(ПродолжительностьСтажа.Лет, ПродолжительностьСтажа.Месяцев, ПродолжительностьСтажа.Дней));
				
			ИначеЕсли ДанныеСтажа.ИсчисляетсяСДатыПриема Тогда
				
				ПредставлениеСтажа = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'С момента приема на работу (%1) на %2 составил %3';
						|en = 'It is %3 from hiring (%1) on %2'"), 
					Формат(ДанныеСтажа.ДатаОтсчета, "ДЛФ=Д"),
					Формат(ДатаСведенийСтажа, "ДЛФ=Д"),
					ЗарплатаКадрыРасширенныйКлиентСервер.ПредставлениеСтажа(ПродолжительностьСтажа.Лет, ПродолжительностьСтажа.Месяцев, ПродолжительностьСтажа.Дней));
				
			Иначе
				
				ПредставлениеСтажа = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'По трудовой книжке на %1 составил %2';
						|en = 'It is %2 on %1 for the employment record book'"), 
					Формат(ДатаСведенийСтажа, "ДЛФ=Д"), 
					ЗарплатаКадрыРасширенныйКлиентСервер.ПредставлениеСтажа(ПродолжительностьСтажа.Лет, ПродолжительностьСтажа.Месяцев, ПродолжительностьСтажа.Дней));
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ДанныеСтажа.ПредставлениеСтажа = ПредставлениеСтажа;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьСведенияОСтаже()
	
	ТекущиеДанные = Элементы.СведенияОСтажах.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ТекущиеДанные.ДатаОтсчета) Тогда 
		Возврат;
	КонецЕсли;
	
	СтрокиСтажа = СтажиФизическихЛиц.НайтиСтроки(Новый Структура("ВидСтажа", ТекущиеДанные.ВидСтажа));
	Для каждого СтрокаСтажа Из СтрокиСтажа Цикл
		СтажиФизическихЛиц.Удалить(СтрокаСтажа);
	КонецЦикла;
	
	ТекущиеДанные.Лет = 0;
	ТекущиеДанные.Месяцев = 0;
	ТекущиеДанные.Дней = 0;
	ТекущиеДанные.ИсчисляетсяСДатыПриема = Ложь;
	ТекущиеДанные.ДатаОтсчета = '00010101';
	ТекущиеДанные.Прерван = Ложь;
	ТекущиеДанные.СостояниеРасчета = 0;
	
	СформироватьПредставлениеСтажа(ТекущиеДанные, СведенияОНакопленныхСтажах, ОбщегоНазначенияКлиент.ДатаСеанса());
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СтажиНеЗаданыГруппа", "Видимость", Не СтажиЗаданы(ЭтотОбъект));
	
	СтрокиОчищаемогоСтажа = ВидыСтажаТрудовойДеятельностиФизическихЛиц.НайтиСтроки(Новый Структура("ВидСтажа", ТекущиеДанные.ВидСтажа));
	Для Каждого СтрокаОчищаемогоСтажа Из СтрокиОчищаемогоСтажа Цикл
		ВидыСтажаТрудовойДеятельностиФизическихЛиц.Удалить(СтрокаОчищаемогоСтажа);
	КонецЦикла;
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьДанные(Отказ) Экспорт
	
	Если Модифицированность Тогда
		
		Если Не Отказ Тогда
			
			Если ПроверитьЗаполнение() Тогда
				
				ВозвращаемыйПараметр = Новый Структура;
				ВозвращаемыйПараметр.Вставить("ИмяФормы", ИмяФормы);
				ВозвращаемыйПараметр.Вставить("АдресВХранилище", АдресДанныхДополнительнойФормыНаСервере(СотрудникиКлиентСервер.ОписаниеДополнительнойФормы(ИмяФормы)));
				
				Оповестить(
					"ИзмененыДанныеДополнительнойФормы",
					ВозвращаемыйПараметр,
					ВладелецФормы);
				
			Иначе
				Отказ = Истина;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИЗакрыть(Результат, ДополнительныеПараметры) Экспорт 
	
	СохранитьИЗакрытьНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИЗакрытьНаКлиенте(ЗакрытьФорму = Истина) Экспорт

	Если Не ТолькоПросмотр Тогда
		ТекущийЭлемент = Элементы.ФормаОк;
	КонецЕсли;
	
	Отказ = Ложь;

	СохранитьДанные(Отказ);
	
	Если НЕ Отказ  Тогда
		
		Модифицированность = Ложь;
		Если ЗакрытьФорму И Открыта() Тогда
			Закрыть();
		Иначе
			ПодключитьОбработчикОжидания("ПослеСохраненияНаКлиенте", 0.5, Истина);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеСохраненияНаКлиенте()
	
	ПослеСохраненияНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПослеСохраненияНаСервере()
	
	Для Каждого Запись Из СтажиФизическихЛиц Цикл
		Запись.ТребуетЗаписи = Ложь;
	КонецЦикла;
	
	ПроинициализироватьФорму();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПредставлениеКомандыИзменитьПроцентСевернойНадбавки(Форма) Экспорт
	ТекстНадписи = НСтр("ru = 'Изменить процент надбавки';
						|en = 'Change standard bonus percent'");
	Если Форма.ПараметрыИсчисленияПроцентаСевернойНадбавкиФизическихЛиц.ПроцентСевернойНадбавки = 0 Тогда
		ТекстНадписи = НСтр("ru = 'Задать процент надбавки';
							|en = 'Set the standard bonus percent'");
	КонецЕсли;
	Возврат ТекстНадписи
КонецФункции

&НаКлиенте
Процедура ФизическоеЛицоПроцентСевернойНадбавкиОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если Параметр.Свойство("ДатаСтажа") Тогда
		
		НайденныеСтроки = СведенияОСтажах.НайтиСтроки(Новый Структура("ВидСтажа", Параметр.ВидСтажа));
		Если НайденныеСтроки.Количество() > 0 Тогда 
			
			СтрокаСтажа = НайденныеСтроки[0];
			
			СтрокаСтажа.ДатаОтсчета = Параметр.ДатаСтажа;
			СтрокаСтажа.Лет = Цел(Параметр.МесяцевСтажа / 12);
			СтрокаСтажа.Месяцев = Параметр.МесяцевСтажа - СтрокаСтажа.Лет * 12;
			СтрокаСтажа.Дней = Параметр.ДнейСтажа;
			
			СформироватьПредставлениеСтажа(СтрокаСтажа, СведенияОНакопленныхСтажах, ОбщегоНазначенияКлиент.ДатаСеанса());
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Параметр.Свойство("ДанныеСтажей") Тогда
		ОбработатьИзменениеСтажаФизическогоЛица(Параметр.ДанныеСтажей, Ложь);
	КонецЕсли;
	
	Если Параметр.Свойство("ВидСтажаПрежний") Тогда
		
		НайденныеСтроки = СведенияОСтажах.НайтиСтроки(Новый Структура("ВидСтажа", Параметр.ВидСтажаПрежний));
		Если НайденныеСтроки.Количество() > 0 Тогда
			
			СтрокаСтажа = НайденныеСтроки[0];
			
			СтрокаСтажа.ДатаОтсчета = '00010101';
			СтрокаСтажа.Период = СтрокаСтажа.ДатаОтсчета;
			
			СтрокаСтажа.Лет = 0;
			СтрокаСтажа.Месяцев = 0;
			СтрокаСтажа.Дней = 0;
			
			СтрокаСтажа.ИсчисляетсяСДатыПриема = Ложь;
			
			СформироватьПредставлениеСтажа(СтрокаСтажа, СведенияОНакопленныхСтажах, ОбщегоНазначенияКлиент.ДатаСеанса());
			
		КонецЕсли;
		
	КонецЕсли;
	
	УстановитьПредставлениеПроцентаСевернойНадбавки();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПредставлениеПроцентаСевернойНадбавки()
	
	ФизическоеЛицоПроцентСевернойНадбавкиТекст = СотрудникиФормыРасширенный.ПредставлениеПроцентаСевернойНадбавки(ФизическоеЛицоСсылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроцентыСевернойНадбавкиИзменить()
	
	ИзСотрудника = ТипЗнч(ВладелецФормы.Параметры.Ключ) = Тип("СправочникСсылка.Сотрудники");
	
	Если ИзСотрудника И ДоступноИзменениеДанныхФизическихЛицЗарплатаКадрыРасширенная Тогда
		ФизлицоЗаблокировано = СотрудникиКлиент.ЗаблокироватьФизическоеЛицоПриРедактировании(ВладелецФормы, Ложь);
	Иначе
		ФизлицоЗаблокировано = Истина;
	КонецЕсли;
	
	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("ФизическоеЛицо", ФизическоеЛицоСсылка);
	ПараметрыОткрытияФормы.Вставить("ТолькоПросмотр", ТолькоПросмотр Или Не  ФизлицоЗаблокировано);
	
	ПараметрыОткрытияФормы.Вставить("СтажиФизическихЛиц", СтажиФизическихЛиц);
	
	ОткрытьФорму("Справочник.ФизическиеЛица.Форма.ФормаРедактированияПроцентаСевернойНадбавки", ПараметрыОткрытияФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Функция АдресДанныхДополнительнойФормыНаСервере(ОписаниеДополнительнойФормы)
	
	Возврат СотрудникиФормы.АдресДанныхДополнительнойФормы(ОписаниеДополнительнойФормы, ЭтотОбъект);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция СтажиЗаданы(Форма)
	
	СтажиЗаданы = Ложь;
	
	Для Каждого СтрокаСтажа Из Форма.СведенияОСтажах Цикл 
		
		Если СтрокаСтажа.ИсчисляетсяСДатыПриема Или ЗначениеЗаполнено(СтрокаСтажа.ДатаОтсчета)
			Или СтрокаСтажа.Лет <> 0 Или СтрокаСтажа.Месяцев <> 0 Или СтрокаСтажа.Дней <> 0 Тогда 
			
			СтажиЗаданы = Истина;
			Прервать;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат СтажиЗаданы;
	
КонецФункции

&НаКлиенте
Функция ЗаблокироватьОбъектВФормеВладельце()
	
	Возврат СотрудникиКлиент.ЗаблокироватьОбъектВФормеВладельцеДополнительнойФормы(ЭтотОбъект, ИзФормыСотрудника);
	
КонецФункции

&НаКлиенте
Процедура РассчитатьСтажиПоТрудовойДеятельностиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		РассчитатьСтажиПоТрудовойДеятельностиНаСервере(Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура РассчитатьСтажиПоТрудовойДеятельностиНаСервере(Результат)
	
	Модифицированность = Истина;
	Если Результат.Свойство("СтажиФизическихЛиц") Тогда
		
		СтажиФизическихЛиц.Очистить();
		Для Каждого СтрокаСтажейФизическихЛиц Из Результат.СтажиФизическихЛиц Цикл
			ЗаполнитьЗначенияСвойств(СтажиФизическихЛиц.Добавить(), СтрокаСтажейФизическихЛиц);
		КонецЦикла;
		
		ЗаполнитьДанныеОСтаже();
		
	КонецЕсли;
	
	Если Результат.Свойство("ТрудоваяДеятельностьФизическихЛиц") Тогда
		
		ТрудоваяДеятельностьФизическихЛиц.Очистить();
		Для Каждого СтрокаТрудовойДеятельности Из Результат.ТрудоваяДеятельностьФизическихЛиц Цикл
			ЗаполнитьЗначенияСвойств(ТрудоваяДеятельностьФизическихЛиц.Добавить(), СтрокаТрудовойДеятельности);
		КонецЦикла;
		
	КонецЕсли;
	
	Если Результат.Свойство("ВидыСтажаТрудовойДеятельностиФизическихЛиц") Тогда
		
		ВидыСтажаТрудовойДеятельностиФизическихЛиц.Очистить();
		Для Каждого СтрокаВидыСтажа Из Результат.ВидыСтажаТрудовойДеятельностиФизическихЛиц Цикл
			ЗаполнитьЗначенияСвойств(ВидыСтажаТрудовойДеятельностиФизическихЛиц.Добавить(), СтрокаВидыСтажа);
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПараметрыОткрытияФормыРасчетаСтажа()
	
	ПараметрыОткрытия = Новый Структура;
	
	ПараметрыОткрытия.Вставить("ФизическоеЛицоСсылка", ФизическоеЛицоСсылка);
	ПараметрыОткрытия.Вставить("СтажиФизическихЛиц", ОбщегоНазначения.ТаблицаЗначенийВМассив(СтажиФизическихЛиц.Выгрузить()));
	ПараметрыОткрытия.Вставить("ТрудоваяДеятельностьФизическихЛиц", ОбщегоНазначения.ТаблицаЗначенийВМассив(ТрудоваяДеятельностьФизическихЛиц.Выгрузить()));
	ПараметрыОткрытия.Вставить("ВидыСтажаТрудовойДеятельностиФизическихЛиц", ОбщегоНазначения.ТаблицаЗначенийВМассив(ВидыСтажаТрудовойДеятельностиФизическихЛиц.Выгрузить()));
	
	Возврат ПараметрыОткрытия;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УпорядочитьЗаписиТрудовойДеятельности(ТрудоваяДеятельностьФизическихЛиц)
	
	ТрудоваяДеятельностьФизическихЛиц.Сортировать("ДатаНачала,ДатаОкончания,Организация,Должность");
	
КонецПроцедуры

&НаКлиенте
Процедура ИмпортСТДРЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		ЗаполнитьТрудовуюДеятельностьПоДаннымФайла(Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТрудовуюДеятельностьПоДаннымФайла(ДанныеФайла)
	
	ТрудоваяДеятельность = ЭлектронныеТрудовыеКнижки.ТрудоваяДеятельностьПоДаннымФайла(
		ФизическоеЛицоСсылка, ДанныеФайла);
	
	Если ТрудоваяДеятельность <> Неопределено И ТрудоваяДеятельность.Количество() > 0 Тогда
		
		УпорядочитьЗаписи = Ложь;
		Для Каждого СтрокаДанных Из ТрудоваяДеятельность Цикл
			
			СтруктураПоиска = Новый Структура("ДатаНачала,ДатаОкончания", СтрокаДанных.ДатаНачала, СтрокаДанных.ДатаОкончания);
			НайденныеСтроки = ТрудоваяДеятельностьФизическихЛиц.НайтиСтроки(СтруктураПоиска);
			Если НайденныеСтроки.Количество() > 0 Тогда
				
				ОрганизацияСтроки = СтрокаДанных.Организация;
				
				ПозицияРеквизитов = СтрНайти(ОрганизацияСтроки, НСтр("ru = ' (ИНН: ';
																	|en = ' (TIN: '"));
				Если ПозицияРеквизитов = 0 Тогда
					ПозицияРеквизитов = СтрНайти(ОрганизацияСтроки, НСтр("ru = ' (Рег. номер: ';
																		|en = ' (Reg. number: '"))
				КонецЕсли;
				
				Если ПозицияРеквизитов > 0 Тогда
					ОрганизацияСтроки = Лев(ОрганизацияСтроки, ПозицияРеквизитов);
				КонецЕсли;
				
				ОрганизацияСтроки = ВРег(СокрЛП(ОрганизацияСтроки));
				ДолжностьСтроки = ВРег(СокрЛП(СтрокаДанных.Должность));
				
				Если СтрДлина(ДолжностьСтроки) > 150 Тогда
					ДолжностьСтроки = СокрЛП(Лев(ДолжностьСтроки, 150));
				КонецЕсли;
				
				ТакаяСтрокаУжеЕсть = Ложь;
				
				Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
					
					Если СтрНайти(ВРег(НайденнаяСтрока.Организация), ОрганизацияСтроки) > 0
						И СтрНайти(ВРег(НайденнаяСтрока.Должность), ДолжностьСтроки) > 0 Тогда
						
						ТакаяСтрокаУжеЕсть = Истина;
						Прервать;
					КонецЕсли;
					
				КонецЦикла;
				
				Если ТакаяСтрокаУжеЕсть Тогда
					Продолжить;
				КонецЕсли;
				
			КонецЕсли;
			
			СтрокаТрудоваяДеятельностьФизическихЛиц = ТрудоваяДеятельностьФизическихЛиц.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТрудоваяДеятельностьФизическихЛиц, СтрокаДанных);
			
			ПроинициализироватьНовуюСтрокуТрудовойДеятельности(СтрокаТрудоваяДеятельностьФизическихЛиц, ФизическоеЛицоСсылка);
			
			УпорядочитьЗаписи = Истина;
			
		КонецЦикла;
		
		Если УпорядочитьЗаписи Тогда
			УпорядочитьЗаписиТрудовойДеятельности(ТрудоваяДеятельностьФизическихЛиц);
			Модифицированность = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПроинициализироватьНовуюСтрокуТрудовойДеятельности(СтрокаТрудоваяДеятельностьФизическихЛиц, ФизическоеЛицоСсылка)
	
	СтрокаТрудоваяДеятельностьФизическихЛиц.ФизическоеЛицо = ФизическоеЛицоСсылка;
	СтрокаТрудоваяДеятельностьФизическихЛиц.ИдентификаторЗаписи = Новый УникальныйИдентификатор;
	
КонецПроцедуры

#КонецОбласти