#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Решение вопросов исполнения задач.
	Если Не ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ДоступенФункционалВерсииСервиса("1.2.7.3") Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("ID") Тогда
		ПредметРассмотренияID = Параметры.ID;
		ПредметРассмотренияТип = Параметры.type;
	Иначе
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ВидВопроса = Параметры.ВидВопроса;
	ВидВопросаID = Параметры.ВидВопросаID;
	ВидВопросаТип = "DMIssueType";
	
	// Файлы. Доступность отдельных команд настраивается при активизации файла в дереве предметов.
	ДоступенЗахватФайлов = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ДоступенФункционалВерсииСервиса("1.4.9.1");
	// Мультипредметность.
	ДоступнаМультипредметность = Ложь;
	
	ИмяПользователя = ПараметрыСеанса.ИнтеграцияС1СДокументооборотИмяПользователя;
	
	ЗаполнитьКарточкуНовогоБизнесПроцесса("DMBusinessProcessIssuesSolution", Параметры);
	Если ВидВопросаID = "ПереносСрока" Тогда //@NON-NLS-1
		Заголовок = НСтр("ru = 'Новый запрос на перенос срока';
						|en = 'New time extension request'");
	Иначе
		Заголовок = НСтр("ru = 'Новый вопрос';
						|en = 'New question'");
	КонецЕсли;
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьПереопределяемый.ДополнительнаяОбработкаФормыБизнесПроцесса(
		ЭтотОбъект,
		Отказ,
		СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Модифицированность Тогда
		Оповещение = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		ТекстПредупреждения = "";
		ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы, ,ТекстПредупреждения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ДокументооборотБизнесПроцесс" Тогда
		Если Параметр.ID = ID Тогда
			ПеречитатьПроцесс();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбработатьФормуПоНаличиюПредметов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ЗадачаНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(ГлавнаяЗадача) Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОткрытьОбъект(ПредметРассмотренияТип, ПредметРассмотренияID, Элемент);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВажностьНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияС1СДокументооборотКлиент.ВыбратьЗначениеИзВыпадающегоСписка(
		"DMBusinessProcessImportance",
		"Важность",
		ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВажностьАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ДанныеДляАвтоПодбора(
			"DMBusinessProcessImportance",
			ДанныеВыбора,
			Текст,
			СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВажностьОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ДанныеДляАвтоПодбора(
			"DMBusinessProcessImportance", ДанныеВыбора, Текст, СтандартнаяОбработка);
		Если ДанныеВыбора.Количество() = 1 Тогда
			ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
				"Важность", ДанныеВыбора[0].Значение, СтандартнаяОбработка, ЭтотОбъект);
			СтандартнаяОбработка = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВажностьОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОбработкаВыбораДанныхДляАвтоПодбора("Важность", ВыбранноеЗначение, СтандартнаяОбработка, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СрокДатаПриИзменении(Элемент)
	
	Если Срок = НачалоДня(Срок) Тогда
		Срок = КонецДня(Срок);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НовыйСрокДатаПриИзменении(Элемент)
	
	ДлительностьПереноса = ИнтеграцияС1СДокументооборотВызовСервера.ПодписьДлительностиПереносаСрока(
		Автор,
		АвторID,
		АвторТип,
		СтарыйСрок,
		НовыйСрок);
	
КонецПроцедуры

&НаКлиенте
Процедура НовыйСрокВремяПриИзменении(Элемент)
	
	ДлительностьПереноса = ИнтеграцияС1СДокументооборотВызовСервера.ПодписьДлительностиПереносаСрока(
		Автор,
		АвторID,
		АвторТип,
		СтарыйСрок,
		НовыйСрок);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияПредметыИФайлыОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДобавитьПредмет(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоПриложений

&НаКлиенте
Процедура ДеревоПриложенийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Строка = Элемент.ТекущиеДанные;
	Если Строка = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Строка.Ссылка) Тогда // Объект ИС.
		ПоказатьЗначение(, Строка.Ссылка);
		
	ИначеЕсли Строка.ПредметТип = "DMFile" Тогда // Файл.
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОткрытьФайл(
			Строка.ПредметID,
			Строка.Предмет,
			Строка.Расширение,
			УникальныйИдентификатор);
		
	Иначе // Объект ДО.
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОткрытьОбъект(Строка.ПредметТип,Строка.ПредметID, Строка);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийПриАктивизацииСтроки(Элемент)
	
	УстановитьДоступностьКомандДереваПриложений();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьБизнесПроцесс(Команда)
	
	Если ПроверитьЗаполнениеБизнесПроцесса() Тогда
		Возврат;
	КонецЕсли;
	
	ЗаписатьОбъект();
	
КонецПроцедуры

&НаКлиенте
Процедура СтартоватьИЗакрыть(Команда)
	
	Если ПроверитьЗаполнениеБизнесПроцесса() Тогда
		Возврат;
	КонецЕсли;
	
	РезультатЗапуска = ПодготовитьКПередачеИСтартоватьБизнесПроцесс();
	
	Если РезультатЗапуска Тогда
		ИнтеграцияС1СДокументооборотКлиент.Оповестить_ЗаписьБизнесПроцесса(ЭтотОбъект, Истина);
		Состояние(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Бизнес-процесс ""%1"" успешно запущен.';
				|en = 'The ""%1"" business process is started successfully.'"), Представление));
		Модифицированность = Ложь;
		Если Открыта() Тогда
			Закрыть();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПредмет(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ДобавитьПредметЗавершение", ЭтотОбъект);
	ИнтеграцияС1СДокументооборотКлиент.ДобавитьПредмет(ЭтотОбъект, "Вспомогательный", ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПредметЗавершение(ДобавленныеПредметы, ПараметрыОбработчика) Экспорт
	
	Если ДобавленныеПредметы = Неопределено Или ДобавленныеПредметы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДобавитьПредметЗавершениеНаСервере(ДобавленныеПредметы);
	Модифицированность = Истина;
	ОбработатьФормуПоНаличиюПредметов();
	
	// Развернем дерево и установим фокус на последнюю строку с добавленным предметом.
	ЭлементыДерева = ДеревоПриложений.ПолучитьЭлементы();
	Для Каждого ЭлементДерева Из ЭлементыДерева Цикл
		ПоследнийИдентификатор = ЭлементДерева.ПолучитьИдентификатор();
		Элементы.ДеревоПриложений.Развернуть(ПоследнийИдентификатор);
	КонецЦикла;
	Элементы.ДеревоПриложений.ТекущаяСтрока = ПоследнийИдентификатор;
	
	Если ДобавленныеПредметы[0].ПредметТип = "DMFile" Тогда
		ЗаписатьОбъект();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьПредметЗавершениеНаСервере(ДобавленныеПредметы)
	
	Дерево = РеквизитФормыВЗначение("ДеревоПриложений");
	
	Для Каждого ОписаниеПредмета Из ДобавленныеПредметы Цикл
		СтрокаПредмета = Дерево.Строки.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаПредмета, ОписаниеПредмета);
		СтрокаПредмета.ДоступноУдаление = Истина;
		Если ЗначениеЗаполнено(СтрокаПредмета.Ссылка) Тогда
			СтрокаПредмета.Представление = Строка(СтрокаПредмета.Ссылка);
		КонецЕсли;
		УстановитьКартинкуПредмета(СтрокаПредмета);
		ДополнитьДеревоПриложенийФайламиПредмета(СтрокаПредмета);
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(Дерево, "ДеревоПриложений");
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьПредмет(Команда)
	
	ТекущиеДанные = Элементы.ДеревоПриложений.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ДеревоПриложений.ПолучитьЭлементы().Удалить(ТекущиеДанные);
	КонецЕсли;
	
	ОбработатьФормуПоНаличиюПредметов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКарточку(Команда)
	
	Строка = Элементы.ДеревоПриложений.ТекущиеДанные;
	Если Строка = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Строка.Ссылка) Тогда // Объект ИС.
		ПоказатьЗначение(, Строка.Ссылка);
		
	Иначе // Объект ДО.
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОткрытьОбъект(Строка.ПредметТип, Строка.ПредметID,
			Элементы.ДеревоПриложенийПредставление);
			
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФайлДляПросмотра(Команда)
	
	Строка = Элементы.ДеревоПриложений.ТекущиеДанные;
	Если Строка <> Неопределено И Строка.ПредметТип = "DMFile" Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОткрытьФайл(
			Строка.ПредметID,
			Строка.Предмет,
			Строка.Расширение,
			УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Редактировать(Команда)
	
	ТекущиеДанные = Элементы.ДеревоПриложений.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Или ТекущиеДанные.ПредметТип <> "DMFile" Тогда
		Возврат;
	КонецЕсли;
	Если ТекущиеДанные.Редактируется И Не ТекущиеДанные.РедактируетсяТекущимПользователем Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Этот файл сейчас редактируется другим пользователем.';
										|en = 'The file is being edited by another user now.'"));
		Возврат;
	КонецЕсли;
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("Команда", "Редактировать");
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"КомандыРедактированияЗавершение", ЭтотОбъект, ПараметрыОповещения);
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОткрытьФайл(
		ТекущиеДанные.ПредметID,
		ТекущиеДанные.Предмет,
		ТекущиеДанные.Расширение,
		УникальныйИдентификатор,
		Ложь,
		ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакончитьРедактирование(Команда)
	
	ТекущиеДанные = Элементы.ДеревоПриложений.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено
			Или ТекущиеДанные.ПредметТип <> "DMFile"
			Или Не ТекущиеДанные.РедактируетсяТекущимПользователем Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("Команда", "ЗакончитьРедактирование");
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"КомандыРедактированияЗавершение", ЭтотОбъект, ПараметрыОповещения);
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ЗакончитьРедактированиеФайла(
		ТекущиеДанные.ПредметID,
		ТекущиеДанные.Предмет,
		ТекущиеДанные.Расширение,
		УникальныйИдентификатор,
		ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьРедактирование(Команда)
	
	ТекущиеДанные = Элементы.ДеревоПриложений.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено
			Или ТекущиеДанные.ПредметТип <> "DMFile"
			Или Не ТекущиеДанные.РедактируетсяТекущимПользователем Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("Команда", "ОтменитьРедактирование");
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"КомандыРедактированияЗавершение", ЭтотОбъект, ПараметрыОповещения);
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОтменитьРедактированиеФайла(
		ТекущиеДанные.ПредметID,
		ОписаниеОповещения,,
		УникальныйИдентификатор);
	
КонецПроцедуры

// Общее завершение команд редактирования.
&НаКлиенте
Процедура КомандыРедактированияЗавершение(Результат, Параметры) Экспорт
	
	СтрокаПредмета = НайтиСтрокуПредмета(ДеревоПриложений.ПолучитьЭлементы(), Результат.ID, Результат.Тип);
	
	Если СтрокаПредмета = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Команда = "Редактировать" Тогда
		СтрокаПредмета.Редактируется = Истина;
		СтрокаПредмета.РедактируетсяТекущимПользователем = Истина;
	Иначе // "ЗакончитьРедактирование" Или "ОтменитьРедактирование".
		СтрокаПредмета.Редактируется = Ложь;
		СтрокаПредмета.РедактируетсяТекущимПользователем = Ложь;
	КонецЕсли;
	УстановитьДоступностьКомандДереваПриложений();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Функция НайтиСтрокуПредмета(СтрокиДерева, ПредметID, ПредметТип)
	
	НайденнаяСтрока = Неопределено;
	
	Для Каждого СтрокаПредмета Из СтрокиДерева Цикл
		
		Если ПредметID = СтрокаПредмета.ПредметID И ПредметТип = СтрокаПредмета.ПредметТип Тогда
			НайденнаяСтрока = СтрокаПредмета;
		Иначе
			Если ТипЗнч(СтрокаПредмета) = Тип("ДанныеФормыЭлементДерева") Тогда
				СтрокиФайлов = СтрокаПредмета.ПолучитьЭлементы();
			Иначе
				СтрокиФайлов = СтрокаПредмета.Строки;
			КонецЕсли;
			Для Каждого СтрокаФайла Из СтрокиФайлов Цикл
				Если ПредметID = СтрокаФайла.ПредметID И ПредметТип = СтрокаФайла.ПредметТип Тогда
					НайденнаяСтрока = СтрокаФайла;
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		Если НайденнаяСтрока <> Неопределено Тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат НайденнаяСтрока;
	
КонецФункции

&НаКлиенте
Процедура УстановитьДоступностьКомандДереваПриложений()
	
	ТекущиеДанные = Элементы.ДеревоПриложений.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Элементы.ОткрытьФайлДляПросмотра.Доступность = Ложь;
		Элементы.Редактировать.Доступность = Ложь;
		Элементы.ЗакончитьРедактирование.Доступность = Ложь;
		Элементы.ОтменитьРедактирование.Доступность = Ложь;
		Элементы.УдалитьПредмет.Доступность = Ложь;
		Элементы.ФормаУдалитьПредмет.Доступность = Ложь;
	Иначе
		Если ТекущиеДанные.ПредметТип = "DMFile" Тогда
			Элементы.ОткрытьФайлДляПросмотра.Доступность = Истина;
			Элементы.Редактировать.Доступность = ДоступенЗахватФайлов
				И (Не ТекущиеДанные.Редактируется Или ТекущиеДанные.РедактируетсяТекущимПользователем);
			Элементы.ЗакончитьРедактирование.Доступность = ДоступенЗахватФайлов
				И ТекущиеДанные.РедактируетсяТекущимПользователем;
			Элементы.ОтменитьРедактирование.Доступность = ДоступенЗахватФайлов
				И ТекущиеДанные.РедактируетсяТекущимПользователем;
		Иначе
			Элементы.ОткрытьФайлДляПросмотра.Доступность = Ложь;
			Элементы.Редактировать.Доступность = Ложь;
			Элементы.ЗакончитьРедактирование.Доступность = Ложь;
			Элементы.ОтменитьРедактирование.Доступность = Ложь;
		КонецЕсли;
		Элементы.УдалитьПредмет.Доступность = ТекущиеДанные.ДоступноУдаление И Не ТекущиеДанные.Редактируется;
		Элементы.ФормаУдалитьПредмет.Доступность = ТекущиеДанные.ДоступноУдаление И Не ТекущиеДанные.Редактируется;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПроверитьЗаполнениеБизнесПроцесса()
	
	ЕстьОшибки = Ложь;
	ОчиститьСообщения();
	
	Если Не ЗначениеЗаполнено(Описание) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			?(ВидВопросаID = "ПереносСрока", //@NON-NLS-1
				НСтр("ru = 'Не указано основание для переноса срока.';
					|en = 'Time extension reason is not specified.'"),
				НСтр("ru = 'Поле ""Вопрос"" не заполнено';
					|en = '""Issue"" is required'")),,
			"Описание");
		ЕстьОшибки = Истина;
	КонецЕсли;
	
	Если ВидВопросаID = "ПереносСрока" И Не ЗначениеЗаполнено(НовыйСрок) Тогда //@NON-NLS-1
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не введен новый срок выполнения.';
														|en = 'New due date is not specified.'"),,
			"НовыйСрок");
		ЕстьОшибки = Истина;
	КонецЕсли;
	
	Возврат ЕстьОшибки;
	
КонецФункции

&НаКлиенте
Функция ЗаписатьОбъект() Экспорт
	
	ПодготовитьКПередачеИЗаписатьБизнесПроцесс();
	ИнтеграцияС1СДокументооборотКлиент.Оповестить_ЗаписьБизнесПроцесса(ЭтотОбъект, Ложь);
	Заголовок = Представление;
	Состояние(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Бизнес-процесс ""%1"" сохранен.';
			|en = 'Business process ""%1"" is saved.'"), Представление));
	Модифицированность = Ложь;
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьКарточкуНовогоБизнесПроцесса(ТипБизнесПроцесса, Предмет)
	
	Прокси = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ПолучитьПрокси();
	НовыйОбъект = ИнтеграцияС1СДокументооборотБазоваяФункциональность.НовыйОбъектДО(
		Прокси,
		ТипБизнесПроцесса,
		Предмет);
	
	ЗаполнитьФормуИзОбъектаXDTO(НовыйОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьФормуИзОбъектаXDTO(ОбъектXDTO, ОбновлятьПредметы = Истина)
	
	Если ОбъектXDTO.Установлено("objectID") Тогда
		ID = ОбъектXDTO.objectID.ID;
		Тип = ОбъектXDTO.objectID.type;
	КонецЕсли;
	
	Если Не ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ДоступенФункционалВерсииСервиса("2.1.18.1") Тогда
		Элементы.ФормаДобавитьПредмет.Видимость = Ложь;
		Элементы.ФормаУдалитьПредмет.Видимость = Ложь;
	КонецЕсли;
	
	Обработки.ИнтеграцияС1СДокументооборотБазоваяФункциональность.УстановитьНавигационнуюСсылку(
		ЭтотОбъект,
		ОбъектXDTO);
	Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьСтандартнуюШапкуБизнесПроцесса(ЭтотОбъект, ОбъектXDTO);
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ЗаполнитьОбъектныйРеквизит(ЭтотОбъект,
		ОбъектXDTO.initiator,
		"ИнициаторПроцесса");
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ЗаполнитьОбъектныйРеквизит(ЭтотОбъект,
		ОбъектXDTO.issueTask,
		"ПредметРассмотрения", Истина);
	
	Элементы.ГруппаПереносСрока.Видимость = Ложь;
	Элементы.Описание.ПодсказкаВвода = НСтр("ru = 'Текст вопроса';
											|en = 'Issue text'");
	Элементы.Описание.Подсказка = НСтр("ru = 'Текст вопроса';
										|en = 'Issue text'");
	Элементы.ФормаСтартИЗакрыть.Заголовок = НСтр("ru = 'Задать вопрос и закрыть';
												|en = 'Ask a question and close'");
	
	Если ВидВопросаID = "ПереносСрока" Тогда //@NON-NLS-1
		Элементы.ГруппаПереносСрока.Видимость = Истина;
		Элементы.Описание.ПодсказкаВвода = НСтр("ru = 'Обоснование запроса';
												|en = 'Request justification'");
		Элементы.Описание.Подсказка = НСтр("ru = 'Обоснование запроса';
											|en = 'Request justification'");
		Элементы.ФормаСтартИЗакрыть.Заголовок = НСтр("ru = 'Отправить запрос и закрыть';
													|en = 'Send request and close'");
		
		СтарыйСрок = ОбъектXDTO.issueTask.dueDate;
		НовыйСрок = СтарыйСрок + 86400;
		
		Если ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ДоступенФункционалВерсииСервиса("2.1.18.1.CORP") Тогда
			Элементы.ДлительностьПереноса.Видимость = Истина;
			ДлительностьПереноса = ИнтеграцияС1СДокументооборотВызовСервера.ПодписьДлительностиПереносаСрока(
				Автор,
				АвторID,
				АвторТип,
				СтарыйСрок,
				НовыйСрок);
		Иначе
			Элементы.ДлительностьПереноса.Видимость = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ДоступенФункционалВерсииСервиса("2.1.18.1") Тогда
		Элементы.ГруппаПриложения.Видимость = Истина;
		Если ОбновлятьПредметы И ИнтеграцияС1СДокументооборотБазоваяФункциональность.СвойствоУстановлено(ОбъектXDTO, "files") Тогда
			ЗаполнитьДеревоПриложенийПоФайлам(ОбъектXDTO.files);
		КонецЕсли;
	Иначе
		Элементы.ГруппаПриложения.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СоздатьОбъект(Прокси, Тип)
	
	Возврат ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, Тип);
	
КонецФункции

&НаСервере
Функция ПодготовитьКПередачеИЗаписатьБизнесПроцесс()
	
	Прокси = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ПолучитьПрокси();
	ОбъектXDTO = ПодготовитьБизнесПроцесс(Прокси);
	Если ЗначениеЗаполнено(ID) Тогда
		РезультатЗаписи = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ЗаписатьОбъект(Прокси, ОбъектXDTO);
	Иначе
		РезультатСоздания = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьНовыйОбъект(Прокси, ОбъектXDTO);
	КонецЕсли;
	
	Результат = ?(РезультатСоздания = Неопределено, РезультатЗаписи, РезультатСоздания);
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПроверитьВозвратВебСервиса(Прокси, Результат);
	
	Если РезультатЗаписи <> Неопределено Тогда
		УстановитьСсылкуБизнесПроцесса(Результат.objects[0]);
	Иначе
		УстановитьСсылкуБизнесПроцесса(Результат.object);
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Функция ПодготовитьКПередачеИСтартоватьБизнесПроцесс()
	
	Прокси = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ПолучитьПрокси();
	ОбъектXDTO = ПодготовитьБизнесПроцесс(Прокси);
	
	РезультатЗапуска = ИнтеграцияС1СДокументооборот.ЗапуститьБизнесПроцесс(Прокси, ОбъектXDTO);
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПроверитьВозвратВебСервиса(Прокси, РезультатЗапуска);
	
	УстановитьСсылкуБизнесПроцесса(РезультатЗапуска.businessProcess);
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Функция ПодготовитьБизнесПроцесс(Прокси)
	
	ОбъектXDTO = Обработки.ИнтеграцияС1СДокументооборот.ПодготовитьШапкуБизнесПроцесса(
		Прокси,
		"DMBusinessProcessIssuesSolution",
		ЭтотОбъект,
		"Шаблон");
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ЗаполнитьОбъектXDTOИзОбъектногоРеквизита(Прокси,
		ЭтотОбъект,
		"ИнициаторПроцесса",
		ОбъектXDTO.initiator,
		"DMUser");
	
	Прокси = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ПолучитьПрокси();
	ЗадачаXDTO = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПолучитьОбъект(
		Прокси,
		ПредметРассмотренияТип,
		ПредметРассмотренияID);
	ЗадачаПриемник = СоздатьОбъект(
		Прокси,
		"DMBusinessProcessTask");
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ЗаполнитьЗначенияСвойствXDTO(
		Прокси,
		ЗадачаПриемник,
		ЗадачаXDTO);
	ОбъектXDTO.issueTask = ЗадачаПриемник;
	Если ИнтеграцияС1СДокументооборотБазоваяФункциональность.СвойствоСуществует(ОбъектXDTO, "issueType") Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональность.ЗаполнитьОбъектXDTOИзОбъектногоРеквизита(Прокси,
			ЭтотОбъект,
			"ВидВопроса",
			ОбъектXDTO.issueType,
			ВидВопросаТип);
	КонецЕсли;
	Если ИнтеграцияС1СДокументооборотБазоваяФункциональность.СвойствоСуществует(ОбъектXDTO, "newDueDate") Тогда
		ОбъектXDTO.newDueDate = НовыйСрок;
	КонецЕсли;
	
	Если ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ДоступенФункционалВерсииСервиса("2.1.18.1") Тогда
		ЗаполнитьПредметамиИзДереваПриложений(Прокси, ДеревоПриложений.ПолучитьЭлементы(), ОбъектXDTO);
	КонецЕсли;
	
	Возврат ОбъектXDTO;
	
КонецФункции

&НаСервере
Процедура УстановитьСсылкуБизнесПроцесса(ОбъектXDTO)
	
	ID = ОбъектXDTO.objectID.ID;
	Если ОбъектXDTO.objectID.Свойства().Получить("presentation") <> Неопределено Тогда
		Представление = ОбъектXDTO.objectID.presentation;
	Иначе
		Представление = ОбъектXDTO.name;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Ответ, ПараметрыОповещения) Экспорт
	
	Если ПроверитьЗаполнениеБизнесПроцесса() Тогда
		Возврат;
	КонецЕсли;
	
	ЗаписатьОбъект();
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПрограммноДобавленнуюКоманду(Команда)
	
	// Вызовем обработчик команды, которая добавлена программно при создании формы на сервере.
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиентПереопределяемый.ВыполнитьПрограммноДобавленнуюКоманду(Команда, ЭтотОбъект);
	
КонецПроцедуры

// Устанавливает картинку предмета по его роли или по расширению файла.
//
&НаСервере
Процедура УстановитьКартинкуПредмета(СтрокаПредмета)
	
	Если СтрокаПредмета.ПредметТип = "DMFile" Тогда
		// Для файла - по расширению.
		СтрокаПредмета.Картинка =
			ИнтеграцияС1СДокументооборотБазоваяФункциональность.ИндексПиктограммыФайла(СтрокаПредмета.Расширение);
	Иначе
		// Для прочих типов - по роли.
		СтрокаПредмета.Картинка = ИнтеграцияС1СДокументооборотКлиентСервер.КартинкаПоРолиПредмета(
			СтрокаПредмета.РольПредмета);
	КонецЕсли;
	
КонецПроцедуры

// Получает вызовом сервиса файлы предмета и дополняет ими дерево приложений.
//
&НаСервере
Процедура ДополнитьДеревоПриложенийФайламиПредмета(СтрокаПредмета)
	
	Если СтрокаПредмета.ПредметТип = "DMFile" Тогда
		Возврат;
	КонецЕсли;
	
	СписокФайлов = ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ФайлыПоВладельцу(
		СтрокаПредмета.ПредметID,
		СтрокаПредмета.Предмет,
		СтрокаПредмета.ПредметТип);
	ДополнитьДеревоПриложенийФайлами(СтрокаПредмета.Строки, СписокФайлов.files);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоПриложенийПоФайлам(ФайлыXDTO)
	
	Дерево = РеквизитФормыВЗначение("ДеревоПриложений");
	
	ДополнитьДеревоПриложенийФайлами(Дерево.Строки, ФайлыXDTO, Истина);
	
	ЗначениеВРеквизитФормы(Дерево, "ДеревоПриложений");
	
КонецПроцедуры

&НаСервере
Процедура ДополнитьДеревоПриложенийФайлами(СтрокиДерева, ФайлыXDTO, ДоступноУдаление = Ложь)
	
	СтрокиДерева.Очистить();
	
	Для Каждого ФайлXDTO Из ФайлыXDTO Цикл
		СтрокаФайла = СтрокиДерева.Добавить();
		СтрокаФайла.Предмет = ФайлXDTO.name;
		СтрокаФайла.ПредметТип = ФайлXDTO.objectID.type;
		СтрокаФайла.ПредметID = ФайлXDTO.objectID.ID;
		СтрокаФайла.Расширение = ФайлXDTO.extension;
		
		ПометкаУдаления = Ложь;
		Если ИнтеграцияС1СДокументооборотБазоваяФункциональность.СвойствоУстановлено(ФайлXDTO, "deletionMark") Тогда
			ПометкаУдаления = ФайлXDTO.deletionMark;
		КонецЕсли;
		СтрокаФайла.Картинка =
			ИнтеграцияС1СДокументооборотБазоваяФункциональность.ИндексПиктограммыФайла(
				СтрокаФайла.Расширение,
				ПометкаУдаления);
		
		Если ДоступенЗахватФайлов Тогда
			СтрокаФайла.Редактируется = ФайлXDTO.editing;
			Если ФайлXDTO.Установлено("editingUser") Тогда
				СтрокаФайла.РедактируетсяТекущимПользователем =
					(ВРег(ФайлXDTO.editingUser.name) = ВРег(ИмяПользователя));
			КонецЕсли;
		КонецЕсли;
		СтрокаФайла.Представление = СтрокаФайла.Предмет;
		СтрокаФайла.ДоступноУдаление = ДоступноУдаление;
	КонецЦикла;
	
КонецПроцедуры

// Управляет видимостью элементов формы в зависимости от наличия предметов.
&НаКлиенте
Процедура ОбработатьФормуПоНаличиюПредметов()
	
	ЕстьПредметы = (ДеревоПриложений.ПолучитьЭлементы().Количество() <> 0);
	Если ЕстьПредметы Тогда
		Если Элементы.ГруппаПриложения.ТекущаяСтраница = Элементы.СтраницаНетПредметов Тогда
			Элементы.ГруппаПриложения.ТекущаяСтраница = Элементы.СтраницаЕстьПредметы;
		КонецЕсли;
	Иначе
		Если Элементы.ГруппаПриложения.ТекущаяСтраница = Элементы.СтраницаЕстьПредметы Тогда
			Элементы.ГруппаПриложения.ТекущаяСтраница = Элементы.СтраницаНетПредметов;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПеречитатьПроцесс()
	
	ПараметрыПолучения = Новый Структура("ID, type", ID, Тип);
	ОбъектXDTO = ИнтеграцияС1СДокументооборот.ПолучитьОбъектXDTOПроцесса(Тип, ПараметрыПолучения);
	ЗаполнитьФормуИзОбъектаXDTO(ОбъектXDTO, Ложь);
	
КонецПроцедуры

// Заполняет объект XDTO задачи бизнес-процесса предметами из дерева приложений формы.
//
&НаСервере
Процедура ЗаполнитьПредметамиИзДереваПриложений(Прокси, СтрокиДерева, ОбъектXDTO)
	
	ОбъектXDTO.files.Очистить();
	
	Для Каждого СтрокаПредмета Из СтрокиДерева Цикл
		
		file = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, СтрокаПредмета.ПредметТип);
		file.name = СтрокаПредмета.Предмет;
		file.objectID = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьObjectID(
			Прокси,
			СтрокаПредмета.ПредметID,
			СтрокаПредмета.ПредметТип);
		
		ОбъектXDTO.files.Добавить(file);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти