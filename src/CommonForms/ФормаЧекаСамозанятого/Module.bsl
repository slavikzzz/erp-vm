#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры, "НомерЧека, СсылкаНаЧек, ЧекСамозанятого, ФайлЧека, ДокументВладелец");
	
	Если НомерЧека = "" Тогда
		ЭтоНовый = Истина;
	КонецЕсли;
	
	ПредыдущееЗначениеСсылкиНаЧек = СсылкаНаЧек;
	
	Если ЗначениеЗаполнено(ФайлЧека) Тогда
		ЧекСамозанятого = РаботаСФайлами.ДвоичныеДанныеФайла(ФайлЧека);
	КонецЕсли;
	
	ВывестиКартинку(АдресКартинки, СсылкаНаЧек, ЧекСамозанятого);
	
	Если ПустаяСтрока(АдресКартинки)
		И ЗначениеЗаполнено(ЧекСамозанятого) Тогда
		АдресКартинки = ПоместитьВоВременноеХранилище(ЧекСамозанятого);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДокументВладелец) Тогда
		
		Если Не ПравоДоступа("Изменение", ДокументВладелец.Метаданные()) Тогда
			ТолькоПросмотр = Истина;
			Элементы.ГруппаОчиститьЗагрузить.Видимость = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СсылкаНаЧекПриИзменении(Элемент)
	
	Если СсылкаНаЧек = ПредыдущееЗначениеСсылкиНаЧек Тогда
		Возврат;
	КонецЕсли;
	
	ОчиститьСообщения();
	
	ПредыдущееЗначениеСсылкиНаЧек = СсылкаНаЧек;
	СсылкаНаЧекПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура АдресКартинкиНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Не ЗначениеЗаполнено(АдресКартинки) Тогда
		ЗагрузитьФайл();
	Иначе
		
		ВременныйФайл = ПолучитьВременныйФайлЧека(ЧекСамозанятого);
		ФайловаяСистемаКлиент.ОткрытьФайл(ВременныйФайл, , "jpg");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьЧекНажатие(Элемент)
	
	Модифицированность = Истина;
	СсылкаНаЧек = "";
	НомерЧека = "";
	АдресКартинки = "";
	ПредыдущееЗначениеСсылкиНаЧек = "";
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьЧекНажатие(Элемент)
	
	ЗагрузитьФайл();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПерейтиПоСсылке(Команда)
	
	Если ЗначениеЗаполнено(СсылкаНаЧек) Тогда
		ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(СсылкаНаЧек);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Если ПроверитьЗаполнение() Тогда
		
		Чек = Новый Структура;
		Чек.Вставить("СсылкаНаЧек", СсылкаНаЧек);
		Чек.Вставить("НомерЧека", НомерЧека);
		Чек.Вставить("ЧекСамозанятого", ПолучитьИзВременногоХранилища(АдресКартинки));
		
		Если ЗначениеЗаполнено(ДокументВладелец) Тогда
			
			Если Модифицированность Тогда
				
				Если ЭтоНовый Тогда
					СохранитьЧек(Чек);
				Иначе
					ИзменитьЧек(Чек);
				КонецЕсли;
				
				Закрыть(Чек);
				Возврат;
				
			КонецЕсли;
			
			Закрыть(Неопределено);
			
		Иначе
			Закрыть(Чек);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ДобавлениеЧекаСамозанятогоЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	АдресКартинки = Результат.Адрес;

	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

// Выводит информацию о ходе выполнения загрузки.
// 
// Параметры:
//  ПомещаемыйФайл - СсылкаНаФайл - сведения о загружаемом файле.
//  Помещено - Число - процент выполнения.
//  ОтказОтПомещенияФайла - Булево - признак отмены выполнения.
//  ДополнительныеПараметры - Неопределено - дополнительные параметры.
// 
&НаКлиенте
Процедура ОтобразитьСостояниеЗагрузки(ПомещаемыйФайл, Помещено, ОтказОтПомещенияФайла, ДополнительныеПараметры) Экспорт

	ТекстВыполнения = СтрШаблон(НСтр("ru = 'Загружается файл: %1';
									|en = 'Importing the file: %1'"), ПомещаемыйФайл.Имя);
	Состояние(ТекстВыполнения, Помещено);

КонецПроцедуры

&НаКлиенте
Процедура ПроверитьФайлПередЗагрузкой(ПомещаемыйФайл, ОтказОтПомещенияФайла, ДополнительныеПараметры) Экспорт

	ДанныеФайла = Новый ДвоичныеДанные(ПомещаемыйФайл.Файл.ПолноеИмя);
	
	Картинка = Новый Картинка(ДанныеФайла);
	
	Если Картинка.Формат() = Неопределено
		Или Картинка.Формат() = ФорматКартинки.НеизвестныйФормат Тогда
		
		ТекстПредупреждения = НСтр("ru = 'Файл не является картинкой';
									|en = 'The file is not a picture'");
		ОтказОтПомещенияФайла = Истина;
		ПоказатьПредупреждение(, ТекстПредупреждения);
	
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Процедура ВывестиКартинку(АдресКартинки, СсылкаНаЧек, ЧекСамозанятого)
	
	Если Не ЗначениеЗаполнено(СсылкаНаЧек)
		И Не ЗначениеЗаполнено(ЧекСамозанятого) Тогда // открываем для загрузки, данных нет
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ЧекСамозанятого) Тогда
		АдресКартинки = ПоместитьВоВременноеХранилище(ЧекСамозанятого, Новый УникальныйИдентификатор);
	Иначе
	
		Адрес = СсылкаНаЧек;
		
		ПараметрыПолучения = ПолучениеФайловИзИнтернетаКлиентСервер.ПараметрыПолученияФайла();
		ПараметрыПолучения.Таймаут = 1260;
		
		Результат = ПолучениеФайловИзИнтернета.СкачатьФайлВоВременноеХранилище(Адрес, ПараметрыПолучения);
		
		Если Результат.Статус Тогда
			АдресКартинки = Результат.Путь;
			ЧекСамозанятого = ПолучитьИзВременногоХранилища(АдресКартинки);
		Иначе
			ТекстОшибки = НСтр("ru = 'Не удалось получить чек самозанятого.
				|Описание: %1
				|URL: %2';
				|en = 'Cannot get a self-employed person receipt.
				|Details: %1
				|URL: %2'");
			ТекстОшибки = ТекстОшибки + Символы.ПС + НСтр("ru = 'Код ошибки: %3';
															|en = 'Error code: %3'");
			ТекстОшибки = СтрШаблон(ТекстОшибки, Результат.СообщениеОбОшибке, Адрес, Результат.КодСостояния);
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СсылкаНаЧекПриИзмененииСервер()

	Если СтрНайти(СсылкаНаЧек, ДенежныеСредстваПовтИспРФ.АдресСервисаФНС()) = 0 Тогда
		// Это не ссылка на чек, поэтому ничего не делаем
		Возврат;
	КонецЕсли;
	
	ПолучитьДанныеПоСсылкеНаЧек();
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	
	Элементы.ЗагрузитьЧек.Видимость = Не ЗначениеЗаполнено(Форма.АдресКартинки);
	Элементы.ОчиститьЧек.Видимость = ЗначениеЗаполнено(Форма.АдресКартинки);
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьДанныеПоСсылкеНаЧек()
	
	НомерЧека = ДенежныеСредстваСерверЛокализация.НомерЧекаИзСсылки(СсылкаНаЧек);
	
	Если ЗначениеЗаполнено(СсылкаНаЧек) Тогда
		ЧекСамозанятого = Неопределено;
		ВывестиКартинку(АдресКартинки, СсылкаНаЧек, ЧекСамозанятого);
	Иначе
		ТекстСообщения = НСтр("ru = 'Не удалось скачать чек с сайта ФНС. 
			|Проверьте ссылку или попробуйте получить чек позднее';
			|en = 'Cannot download the receipt from the FTS website.
			|Check the link or try again later'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , "СсылкаНаЧек");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьФайл()

	ОбработчикЗавершенияЗагрузки = Новый ОписаниеОповещения("ДобавлениеЧекаСамозанятогоЗавершение", ЭтотОбъект);
	ОбработчикСостоянияЗагрузки = Новый ОписаниеОповещения("ОтобразитьСостояниеЗагрузки", ЭтотОбъект);
	ОбработчикПроверкиФайла = Новый ОписаниеОповещения("ПроверитьФайлПередЗагрузкой", ЭтотОбъект);
	
	ПараметрыДиалога = Новый ПараметрыДиалогаПомещенияФайлов;
	ПараметрыДиалога.Заголовок = НСтр("ru = 'Выбор файла чека.';
										|en = 'Select a receipt file.'");
	ПараметрыДиалога.МножественныйВыбор = Ложь;
	
	НачатьПомещениеФайлаНаСервер(ОбработчикЗавершенияЗагрузки,
								ОбработчикСостоянияЗагрузки,
								ОбработчикПроверкиФайла, ,
								ПараметрыДиалога,
								УникальныйИдентификатор);

КонецПроцедуры

&НаСервере
Процедура СохранитьЧек(Чек)

	ДенежныеСредстваСерверЛокализация.СохранитьЧекСамозанятого(ДокументВладелец, Чек);

КонецПроцедуры

&НаСервере
Процедура ИзменитьЧек(Чек)

	НачатьТранзакцию();
	
	Попытка
		
		Блокировка = Новый БлокировкаДанных();
		ЭлементБлокировки = Блокировка.Добавить(ФайлЧека.Метаданные().ПолноеИмя());
		ЭлементБлокировки.УстановитьЗначение("Ссылка", ФайлЧека);
		Блокировка.Заблокировать();

		ФайлОбъект = ФайлЧека.ПолучитьОбъект();
		ФайлОбъект.Заблокировать();
		ФайлОбъект.УстановитьПометкуУдаления(Истина);
		
		ДенежныеСредстваСерверЛокализация.СохранитьЧекСамозанятого(ДокументВладелец, Чек);

		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ВызватьИсключение;
		
	КонецПопытки;

КонецПроцедуры

// Возвращает путь к временному файлу по данным чека.
// 
// Параметры:
//  ЧекСамозанятого - ДвоичныеДанные - чек самозанятого.
// 
// Возвращаемое значение:
//  Строка - путь временного файла.
//
&НаСервереБезКонтекста
Функция ПолучитьВременныйФайлЧека(ЧекСамозанятого)

	ВременныйФайл = ПолучитьИмяВременногоФайла("jpg");
	ЧекСамозанятого.Записать(ВременныйФайл);
	
	Возврат ВременныйФайл;

КонецФункции

#КонецОбласти