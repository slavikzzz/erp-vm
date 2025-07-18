
#Область ОбработчикиСобытийФормы


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РеквизитыНастройкиОбмена = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
		Параметры.НастройкаОбмена, "ЛогинДляПолученияВыписки, СпособПолученияПароля");
	
	Логин = РеквизитыНастройкиОбмена.ЛогинДляПолученияВыписки;
	Элементы.Пояснение.Заголовок = РеквизитыНастройкиОбмена.СпособПолученияПароля;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗапуститьАвтоматическоеПолучениеВыписки(Команда)
	
	ОчиститьСообщения();
	Если Не ЗначениеЗаполнено(Пароль) Тогда
		ТекстСообщения = НСтр("ru = 'Введите пароль.';
								|en = 'Enter password'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "Пароль");
		Возврат;
	КонецЕсли;
	
	СохранитьПарольВБезопасномХранилище(Пароль);
	
	Оповещение = Новый ОписаниеОповещения("ПослеТестовогоПолученияВыписки", ЭтотОбъект);
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("НастройкаОбмена", Параметры.НастройкаОбмена);
	ПараметрыФормы.Вставить("ВидОперации", "ПробноеПолучениеВыписки");
	ОткрытьФорму("Обработка.ОбменСБанками.Форма.ЗапросВБанк", ПараметрыФормы, ЭтотОбъект, , , , Оповещение,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПослеТестовогоПолученияВыписки(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Истина Тогда
		ЗарегистрироватьАвтоматическоеПолучениеВыписки(Параметры.НастройкаОбмена, Пароль);
		Закрыть(Истина);
	Иначе
		Если ТипЗнч(Результат) = Тип("Строка") Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(Результат);
		КонецЕсли;
		Пароль = "";
		УдалитьПарольИзБезопасногоХранилища(Параметры.НастройкаОбмена);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УдалитьПарольИзБезопасногоХранилища(Знач НастройкаОбмена)
	
	УстановитьПривилегированныйРежим(Истина);
	ОбменСБанкамиСлужебный.УдалитьПарольИзБезопасногоХранилища(НастройкаОбмена);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗарегистрироватьАвтоматическоеПолучениеВыписки(Знач НастройкаОбмена, Знач Пароль)
	
	МенеджерЗаписи = РегистрыСведений.ПараметрыОбменСБанками.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.НастройкаОбмена = НастройкаОбмена;
	МенеджерЗаписи.Прочитать();
	МенеджерЗаписи.НастройкаОбмена = НастройкаОбмена;
	МенеджерЗаписи.АвтоматическоеПолучениеВыписки = Истина;
	МенеджерЗаписи.Записать();
	
	УстановитьПривилегированныйРежим(Истина);
	Если Не ОбщегоНазначения.РазделениеВключено() Тогда
		
		// Ищем задание по наименованию.
		Отбор = Новый Структура();
		Отбор.Вставить("Метаданные", "ПолучениеВыпискиОбменСБанками");
		Задания = РегламентныеЗаданияСервер.НайтиЗадания(Отбор);

		// Проверяем, что задание найдено.
		Если Задания.Количество() <> 1 Тогда
			// Запись в журнал ошибки опущена.
			Возврат;
		КонецЕсли;

		// Включаем найденное задание.
		НашеЗадание = Задания[0];
		ПараметрыРегламентногоЗадания = Новый Структура();
		ПараметрыРегламентногоЗадания.Вставить("Использование", Истина);
		РегламентныеЗаданияСервер.ИзменитьЗадание(НашеЗадание.УникальныйИдентификатор, ПараметрыРегламентногоЗадания);

	КонецЕсли;
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

&НаСервере
Процедура СохранитьПарольВБезопасномХранилище(Знач Пароль)
	
	УстановитьПривилегированныйРежим(Истина);
	ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(Параметры.НастройкаОбмена, Пароль);
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

#КонецОбласти