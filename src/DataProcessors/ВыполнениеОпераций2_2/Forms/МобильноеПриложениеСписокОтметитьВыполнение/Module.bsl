#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	МожноВыполнять = Параметры.МожноВыполнять;
	Подразделение  = Параметры.ПодразделениеОтбор;
	Участок        = Параметры.УчастокОтбор;
	ВидРЦ          = Параметры.ВидРЦОтбор;
	РабочийЦентр   = Параметры.РабочийЦентрОтбор;
	Операция       = Параметры.ОперацияОтбор;
	Изделие        = Параметры.ИзделиеОтбор;
	Исполнитель    = Параметры.ИсполнительОтбор;
	Этап           = Параметры.ЭтапОтбор;
	Партия         = Параметры.ПартияОтбор;
	
	ИспользуютсяСменныеЗадания = 
		ПроизводствоСервер.ПараметрыПроизводственногоПодразделения(Подразделение).ИспользоватьСменныеЗадания;
	
	Операции.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить(
																	"ИспользуютсяСменныеЗадания",
																	ИспользуютсяСменныеЗадания);
	
	ИспользоватьДополнительныеРеквизитыИСведения = ПолучитьФункциональнуюОпцию(
													"ИспользоватьДополнительныеРеквизитыИСведения");
	
	ЭтоМобильныйКлиент = ОбщегоНазначения.ЭтоМобильныйКлиент();
	
	Элементы.СменноеЗаданиеПредставление.Видимость = ИспользуютсяСменныеЗадания;
	
	РежимПринятияВРаботу = Параметры.Свойство("РежимРаботы") И Параметры.РежимРаботы = "ПринятиеВРаботу";
	
	Настройки = Обработки.ВыполнениеОпераций2_2.ПолучитьНастройкиПользователя();
	
	Если Настройки <> Неопределено Тогда
	
		УчастокВНастройках     = ЗначениеЗаполнено(Настройки.Участок);
		РЦВНастройках          = ЗначениеЗаполнено(Настройки.РабочийЦентр);
		ИсполнительВНастройках = ЗначениеЗаполнено(Настройки.Исполнитель);
		
	КонецЕсли;
	
	Элементы.ОперацииКонтекстноеМенюПринятьВРаботу.Видимость        = РежимПринятияВРаботу;
	Элементы.ОперацииКонтекстноеМенюОтметитьВыполнениеЕще.Видимость = РежимПринятияВРаботу;
	Элементы.ОперацииПринятьВРаботу.Видимость                       = РежимПринятияВРаботу;
	
	Элементы.ОперацииКонтекстноеМенюОтметитьВыполнение.Видимость  = Не РежимПринятияВРаботу;
	Элементы.ОперацииКонтекстноеМенюЧастичноеВыполнение.Видимость = Не РежимПринятияВРаботу;
	Элементы.ОперацииЧастичноеВыполнение.Видимость                = Не РежимПринятияВРаботу;
	
	Если РежимПринятияВРаботу Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Операции,
			"Статус",
			ПредопределенноеЗначение("Перечисление.СтатусыПроизводственныхОпераций.Создана"),
			ВидСравненияКомпоновкиДанных.Равно,
			,
			Истина);
		
		Заголовок = НСтр("ru = 'Принятие в работу';
						|en = 'Putting into operation'");
	КонецЕсли;
	
	УстановитьОтборПоСмене();
	
	УстановитьОтборы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	ПараметрыОтбора = Новый Структура();
	
	ПараметрыОтбора.Вставить("МожноВыполнять", МожноВыполнять);
	ПараметрыОтбора.Вставить("ВидРЦ", ВидРЦ);
	ПараметрыОтбора.Вставить("РабочийЦентр", РабочийЦентр);
	ПараметрыОтбора.Вставить("Исполнитель", Исполнитель);
	ПараметрыОтбора.Вставить("Операция", Операция);
	ПараметрыОтбора.Вставить("Изделие", Изделие);
	ПараметрыОтбора.Вставить("Партия", Партия);
	ПараметрыОтбора.Вставить("Этап", Этап);
	ПараметрыОтбора.Вставить("Участок", Участок);
	
	Закрыть(ПараметрыОтбора);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОперации

&НаКлиенте
Процедура ОперацииПриАктивизацииСтроки(Элемент)
	
	Если ЭтоМобильныйКлиент Тогда
		ВидимостьКнопкиОсновногоДействия = ?(Элементы.Операции.ВыделенныеСтроки.Количество()>1,Истина,Ложь);
		
		Элементы.ОтметитьВыполнение.Видимость = ВидимостьКнопкиОсновногоДействия И Не РежимПринятияВРаботу;
		Элементы.ПринятьВРаботу.Видимость     = ВидимостьКнопкиОсновногоДействия И РежимПринятияВРаботу;
		Элементы.Выбрать.Видимость            = НЕ ВидимостьКнопкиОсновногоДействия;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОперацииПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	Сегодня = НачалоДня(ТекущаяДатаСеанса());
	
	СписокКлючей = Строки.ПолучитьКлючи();
	
	Если НЕ Настройки.ДополнительныеСвойства.Свойство("ИспользуютсяСменныеЗадания")
			ИЛИ (Настройки.ДополнительныеСвойства.Свойство("ИспользуютсяСменныеЗадания")
			И НЕ Настройки.ДополнительныеСвойства.ИспользуютсяСменныеЗадания) Тогда
		Возврат
	КонецЕсли; 
	
	ДанныеСмены = ОперативныйУчетПроизводства.ТекущаяСмена(СписокКлючей[0].Подразделение);
	
	Дата = ?(ЗначениеЗаполнено(ДанныеСмены),ДанныеСмены.Дата,Сегодня);
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	СменныеЗадания.Дата КАК Дата,
		|	СменныеЗадания.Смена КАК Смена,
		|	Операции.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.ПроизводственнаяОперация2_2 КАК Операции
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.СменноеЗадание КАК СменныеЗадания
		|		ПО Операции.СменноеЗадание = СменныеЗадания.Ссылка
		|ГДЕ
		|	Операции.Ссылка В(&Ссылки)");
	
	Запрос.УстановитьПараметр("Ссылки", СписокКлючей);
	
	Результат = Запрос.Выполнить().Выбрать();
	
	Пока Результат.Следующий() Цикл
		
		ДатаСмены = Результат.Дата;
		
		СтрокаДата  = Формат(ДатаСмены, "ДФ=dd.MM");
		СтрокаСмена = Строка(Результат.Смена);
		
		Строки[Результат.Ссылка].Данные.СменноеЗаданиеПредставление = СтрокаДата + " " + СтрокаСмена;
			
		Если ДатаСмены < Дата Тогда
			
			Строки[Результат.Ссылка].Оформление["СменноеЗаданиеПредставление"].УстановитьЗначениеПараметра("ЦветТекста",
																											Новый Цвет(255,0,0));
			
		КонецЕсли;
	
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОперацииВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	УправлениеПроизводствомКлиент.ОткрытьФормуДокументаОперации(ВыбраннаяСтрока[0]);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборыСтрокаНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура();
	
	ПараметрыФормы.Вставить("Изделие",Изделие);
	ПараметрыФормы.Вставить("Исполнитель",Исполнитель);
	ПараметрыФормы.Вставить("Операция",Операция);
	ПараметрыФормы.Вставить("ВидРЦ",ВидРЦ);
	ПараметрыФормы.Вставить("РабочийЦентр",РабочийЦентр);
	ПараметрыФормы.Вставить("МожноВыполнять",МожноВыполнять);
	ПараметрыФормы.Вставить("Этап",Этап);
	ПараметрыФормы.Вставить("Партия",Партия);
	ПараметрыФормы.Вставить("Подразделение",Подразделение);
	ПараметрыФормы.Вставить("Участок",Участок);
	
	ОткрытьФорму("Обработка.ВыполнениеОпераций2_2.Форма.МобильноеПриложениеУстановкаОтборов",
		ПараметрыФормы,
		ЭтаФорма,
		,
		,
		,
		Новый ОписаниеОповещения("УстановитьОтборыКлиент",ЭтотОбъект));
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Операции_УстановитьСтатусВыполняется(Команда)
	
	ВыделенныеСтроки = ОбщегоНазначенияУТКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Операции);
	
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ОперативныйУчетПроизводстваКлиент.УстановитьСтатусПроизводственнойОперации(
		ВыделенныеСтроки,
		"Выполняется",
		Подразделение);
	
КонецПроцедуры

&НаКлиенте
Процедура Операции_УстановитьСтатусВыполнена(Команда)
	
	ВыделенныеСтроки = ОбщегоНазначенияУТКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Операции);
	
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПроверкаЗаполненияДопРеквизитов(ВыделенныеСтроки) Тогда
		Возврат;
	КонецЕсли;
	
	ОперативныйУчетПроизводстваКлиент.УстановитьСтатусПроизводственнойОперации(
		ВыделенныеСтроки,
		"Выполнена",
		Подразделение);
	
КонецПроцедуры

&НаКлиенте
Процедура Операции_УстановитьСтатусНеВыполнена(Команда)
	
	ВыделенныеСтроки = ОбщегоНазначенияУТКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Операции);
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ОперативныйУчетПроизводстваКлиент.УстановитьСтатусПроизводственнойОперации(
		ВыделенныеСтроки,
		"НеВыполнена",
		Подразделение);
	
КонецПроцедуры

&НаКлиенте
Процедура ЧастичноеВыполнение(Команда)
	
	Если Не ПроверкаЗаполненияДопРеквизитов(Элементы.Операции.ВыделенныеСтроки) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	
	ПараметрыФормы.Вставить("Ссылка",Элементы.Операции.ТекущаяСтрока);
	
	Оповещение = Новый ОписаниеОповещения("ЧастичноеВыполнениеЗавершение", ЭтаФорма);
	
	ОткрытьФорму("Обработка.ВыполнениеОпераций2_2.Форма.ОтметитьЧастичноеВыполнение",
					ПараметрыФормы, 
					ЭтаФорма,
					,
					,
					,
					Оповещение);
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьНазначение(Команда)
	
	ВыделенныеСтроки = ОбщегоНазначенияУТКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Операции);
	
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ОперативныйУчетПроизводстваКлиент.ОтменитьНазначениеПроизводственнойОпераций(ВыделенныеСтроки, Подразделение);
	
КонецПроцедуры

&НаКлиенте
Процедура ЧастичноеВыполнениеЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	Элементы.Операции.Обновить();
КонецПроцедуры

&НаКлиенте
Процедура СбросОтборов(Команда)
	
	Если НЕ РЦВНастройках Тогда
		ВидРЦ        = Неопределено;
		РабочийЦентр = Неопределено;
	КонецЕсли;
	
	Если НЕ ИсполнительВНастройках Тогда
		Исполнитель = Неопределено;
	КонецЕсли;
	
	Если НЕ УчастокВНастройках Тогда
		Участок = Неопределено;
	КонецЕсли;
	
	Операция = Неопределено;
	Изделие  = Неопределено;
	Этап     = Неопределено;
	Партия   = Неопределено;
	
	УстановитьОтборы();
КонецПроцедуры

#Если МобильныйКлиент Тогда

&НаКлиенте
Процедура СканироватьШтрихКод(Команда)
	
	Если СредстваМультимедиа.ПоддерживаетсяСканированиеШтрихКодов() Тогда
		
		ОбработчикСканирования = Новый ОписаниеОповещения("ОбработкаСканирования", ЭтаФорма);
		
		СредстваМультимедиа.ПоказатьСканированиеШтрихКодов(НСтр("ru = 'Наведите камеру на штрихкод';
																|en = 'Point the camera at the barcode'"),
			ОбработчикСканирования,
			,
			ТипШтрихКода.Линейный);
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаСканирования(Штрихкод, Результат, Сообщение, ДополнительныеПараметры) Экспорт

	Если Результат Тогда
		
		СредстваМультимедиа.ВоспроизвестиЗвуковоеОповещение(ЗвуковоеОповещение.ПоУмолчанию,Истина);
		СредстваМультимедиа.ЗакрытьСканированиеШтрихКодов();
		ЗаполнитьОтбор(Штрихкод);
	Иначе
		
		Сообщение = НСтр("ru = 'Ошибка обработки штрих кода';
						|en = 'Barcode processing error'");
		
	КонецЕсли;
КонецПроцедуры

#КонецЕсли

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Отборы

&НаКлиенте
Процедура УстановитьОтборыКлиент(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	УстановитьОтборы(Результат, ДополнительныеПараметры);
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборы(Результат = Неопределено, ДополнительныеПараметры = Неопределено)
	
	Если Результат <> Неопределено Тогда
		
		МожноВыполнять = Результат.МожноВыполнять;
		ВидРЦ = Результат.ВидРЦ;
		РабочийЦентр = Результат.РабочийЦентр;
		Исполнитель = Результат.Исполнитель;
		Операция = Результат.Операция;
		Изделие = Результат.Изделие;
		Партия = Результат.Партия;
		Этап = Результат.Этап;
		Участок = Результат.Участок;
	
	КонецЕсли;
	
	ОтборыСтрока = "";
	
	УстановитьОтборМожноВыполнять();
	УстановитьОтборПоЭтапу();
	УстановитьОтборПоПартии();
	УстановитьОтборПоИзделию();
	УстановитьОтборПоОперации();
	УстановитьОтборПоИсполнителю();
	УстановитьОтборПоРабочемуЦентру();
	УстановитьОтборПоУчастку();
	УстановитьОтборПоПодразделению();
	
	НастроитьЭлементыОтбора();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборМожноВыполнять()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Операции,
		"МожноНачинать",
		МожноВыполнять,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		МожноВыполнять);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоПодразделению()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Операции,
		"Подразделение",
		Подразделение,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(Подразделение));
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоУчастку()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Операции,
		"Участок",
		Участок,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(Участок));
		
	ДобавитьВСтрокуОтборов(Участок);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоСмене()
	Если ИспользуютсяСменныеЗадания Тогда
		
		ДанныеСмены = ОперативныйУчетПроизводства.ТекущаяСмена(Подразделение);
		
		ДатаОтбора = ?(ЗначениеЗаполнено(ДанныеСмены),ДанныеСмены.Дата,ТекущаяДатаСеанса());
		
		ГруппаСмена = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(
													Операции.Отбор.Элементы,
													"ГруппаСмена",
													ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ);
		
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
			ГруппаСмена,
			"СменноеЗадание.Дата",
			ВидСравненияКомпоновкиДанных.МеньшеИлиРавно,
			ДатаОтбора,
			"Дата",
			Истина);
		
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
			ГруппаСмена,
			"СменноеЗадание.Статус",
			ВидСравненияКомпоновкиДанных.НеРавно,
			ПредопределенноеЗначение("Перечисление.СтатусыСменныхЗаданий.Закрыто"),
			"Смены",
			Истина);
		
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоОперации()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Операции,
		"Операция",
		Операция,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(Операция));
		
	ДобавитьВСтрокуОтборов(Операция);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоИсполнителю()
	
	Если ПроизводствоСервер.ИспользуетсяУчетТрудозатратВРазрезеСотрудников(ТекущаяДатаСеанса()) Тогда
		ФизЛицо = ?(ЗначениеЗаполнено(Исполнитель),
			ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Исполнитель, "ФизическоеЛицо"),
			Неопределено);
		
		Исполнители = Новый Массив;
		Исполнители.Добавить(Исполнитель);
		Исполнители.Добавить(ФизЛицо);
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Операции,
			"Исполнитель",
			Исполнители,
			ВидСравненияКомпоновкиДанных.ВСписке,
			,
			ЗначениеЗаполнено(Исполнитель));
	Иначе
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Операции,
			"Исполнитель",
			Исполнитель,
			ВидСравненияКомпоновкиДанных.Равно,
			,
			ЗначениеЗаполнено(Исполнитель));
	КонецЕсли;
	
	ДобавитьВСтрокуОтборов(Исполнитель);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоИзделию()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Операции,
		"Этап.ПартияПроизводства.ОсновноеИзделиеНоменклатура",
		Изделие,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(Изделие));
		
	ДобавитьВСтрокуОтборов(Изделие);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоПартии()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Операции,
		"Этап.ПартияПроизводства",
		Партия,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(Партия));
		
	ДобавитьВСтрокуОтборов(Партия);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоЭтапу()
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Операции,
		"Этап",
		Этап,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(Этап));
		
	ДобавитьВСтрокуОтборов(Этап);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоРабочемуЦентру()
	
	Если ЗначениеЗаполнено(РабочийЦентр) Тогда
		
		РеквизитыРЦ = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(РабочийЦентр, "ВидРабочегоЦентра.Подразделение, Участок");
		
		ПодразделениеРЦ = РеквизитыРЦ.ВидРабочегоЦентраПодразделение;
		УчастокРЦ       = РеквизитыРЦ.Участок;
		
		Если ПодразделениеРЦ <> Подразделение
			ИЛИ (ЗначениеЗаполнено(Участок) И УчастокРЦ <> Участок) Тогда
			
			ТекстСообщения = НСтр("ru = 'Выбранный рабочий центр не находится в текущем подразделении или участке';
									|en = 'The selected work center is not in the current business unit or site'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
			
			РабочийЦентр = Неопределено;
			
			Возврат;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Операции,
		"РабочийЦентр",
		РабочийЦентр,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(РабочийЦентр));
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Операции,
		"ВидРабочегоЦентра",
		ВидРЦ,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(ВидРЦ));
	
	ДобавитьВСтрокуОтборов(РабочийЦентр);
	
	Если НЕ ЗначениеЗаполнено(РабочийЦентр) Тогда
		ДобавитьВСтрокуОтборов(ВидРЦ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьОтбор(Штрихкод)
	
	Ссылка = ПолучитьСсылку(Штрихкод);
	
	Если ТипЗнч(Ссылка) = Тип("СправочникСсылка.РабочиеЦентры") И НЕ РЦВНастройках Тогда
		
		РабочийЦентр = Ссылка;
		
	ИначеЕсли (ТипЗнч(Ссылка) = Тип("СправочникСсылка.ФизическиеЛица")
		//++ Локализация
		ИЛИ ТипЗнч(Ссылка) = Тип("СправочникСсылка.Сотрудники")
		//-- Локализация
		) И НЕ ИсполнительВНастройках Тогда
		
		Исполнитель = Ссылка;
		
	ИначеЕсли ТипЗнч(Ссылка) = Тип("СправочникСсылка.ТехнологическиеОперации") Тогда
		
		Операция = Ссылка;
		
	ИначеЕсли ТипЗнч(Ссылка) = Тип("СправочникСсылка.Номенклатура") Тогда
		
		Изделие = Ссылка;
		
	ИначеЕсли ТипЗнч(Ссылка) = Тип("СправочникСсылка.ПартииПроизводства") Тогда
		
		Партия = Ссылка;
		
	ИначеЕсли ТипЗнч(Ссылка) = Тип("ДокументСсылка.ЭтапПроизводства2_2") Тогда
		
		Этап = Ссылка;
		
	ИначеЕсли ТипЗнч(Ссылка) = Тип("ДокументСсылка.ПроизводственнаяОперация2_2") Тогда
		
		Элементы.Операции.ТекущаяСтрока = Ссылка;
		
		Возврат;
		
	Иначе
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = Нстр("ru = 'Штрих-код не найден';
								|en = 'Barcode is not found'");
		Сообщение.Сообщить();
		
	КонецЕсли;
	
	УстановитьОтборы();
	
КонецПроцедуры

&НаСервере
Процедура НастроитьЭлементыОтбора()
	
	Если ОтборыСтрока = "" Тогда
		ОтборыСтрока = ?(МожноВыполнять,НСтр("ru = 'Установить отбор*';
											|en = 'Set filter*'"),НСтр("ru = 'Установить отбор';
																			|en = 'Set filter'"));
		Элементы.СбросОтборов.Видимость		= Ложь;
	Иначе
		ОтборыСтрока = Лев(ОтборыСтрока, СтрДлина(ОтборыСтрока)-2);
		Элементы.СбросОтборов.Видимость		= Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьВСтрокуОтборов(Ссылка)
	Если ЗначениеЗаполнено(Ссылка) Тогда
		ОписаниеТиповДокументы = Документы.ТипВсеСсылки();

		СсылкаДокумент = ОписаниеТиповДокументы.СодержитТип(ТипЗнч(Ссылка));
		
		ОтборыСтрока = ОтборыСтрока
			+ ?(СсылкаДокумент,
				ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "Номер"),
				ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "Наименование"))
			+ ", ";
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	// Оформление цветом операций, которые нельзя начинать
	Элемент = Операции.КомпоновщикНастроек.Настройки.УсловноеОформление.Элементы.Добавить();
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("МожноНачинать");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.СерыйЦветТекста1);
	
	// Оформление поля "Статус"
	Элемент = Операции.КомпоновщикНастроек.Настройки.УсловноеОформление.Элементы.Добавить();
	
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных(Элементы.Статус.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Статус");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = ПредопределенноеЗначение("Перечисление.СтатусыПроизводственныхОпераций.Создана");
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", Нстр("ru = 'Назначена';
																|en = 'Assigned'"));
	
	// Оформление поля "Операция"
	Элемент = Операции.КомпоновщикНастроек.Настройки.УсловноеОформление.Элементы.Добавить();
	
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных(Элементы.ОперацииОперация.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Операция");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", Новый ПолеКомпоновкиДанных("Операции.Наименование"));
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСсылку(Штрихкод)
	
	Менеджеры = Новый Массив();
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ЭтапПроизводства2_2.ПустаяСсылка"));
	Менеджеры.Добавить(ПредопределенноеЗначение("Справочник.ПартииПроизводства.ПустаяСсылка"));
	Менеджеры.Добавить(ПредопределенноеЗначение("Справочник.Номенклатура.ПустаяСсылка"));
	Менеджеры.Добавить(ПредопределенноеЗначение("Справочник.ФизическиеЛица.ПустаяСсылка"));
	Менеджеры.Добавить(ПредопределенноеЗначение("Справочник.РабочиеЦентры.ПустаяСсылка"));
	Менеджеры.Добавить(ПредопределенноеЗначение("Справочник.ТехнологическиеОперации.ПустаяСсылка"));
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ПроизводственнаяОперация2_2.ПустаяСсылка"));

	Ссылки = ШтрихкодированиеПечатныхФорм.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод,Менеджеры);
	
	Если Ссылки.Количество() = 1 Тогда
		
		Возврат Ссылки[0];
		
	КонецЕсли;
	Возврат Неопределено;

КонецФункции

&НаКлиенте
Функция ПроверкаЗаполненияДопРеквизитов(Знач ВыделенныеСтроки)
	
	Если ИспользоватьДополнительныеРеквизитыИСведения Тогда
		
		ОперацииСДопРеквизитами = ПолучитьОпеарцииДляЗаполненияДопРеквизитов(ВыделенныеСтроки);
		
		Если ОперацииСДопРеквизитами.Количество() = 1 И ВыделенныеСтроки.Количество() = 1 Тогда
			
			ПараметрыФормы = Новый Структура();
			ПараметрыФормы.Вставить("Ключ", ОперацииСДопРеквизитами[0]);
			ПараметрыФормы.Вставить("Статус", 
				ПредопределенноеЗначение("Перечисление.СтатусыПроизводственныхОпераций.Выполнена"));
			ПараметрыФормы.Вставить("НеЗаполненыДопРеквизиты", Истина);
			ПараметрыФормы.Вставить("ПроверитьПриОткрытии", Истина);

			ОткрытьФорму("Документ.ПроизводственнаяОперация2_2.Форма.ФормаДокумента", ПараметрыФормы);
			
			Возврат Ложь;
			
		ИначеЕсли ВыделенныеСтроки.Количество() > 1 И ОперацииСДопРеквизитами.Количество() > 0 Тогда
			
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Множественное выполнение выделенных операций недоступно.
				|Необходимо ввести контролируемые показатели.';
				|en = 'Multiple execution of selected operations is not available.
				|Controlled indicators must be entered.'"));
			
			Возврат Ложь;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьОпеарцииДляЗаполненияДопРеквизитов(ВыделенныеСтроки)
	
	Результат = Новый Массив();
	
	Для Каждого Ссылка Из ВыделенныеСтроки Цикл
	
		Если УправлениеСвойствами.ИспользоватьДопРеквизиты(Ссылка) Тогда
			
			ДопРеквизиты = УправлениеСвойствами.СвойстваОбъекта(Ссылка);
			
			Для Каждого Реквизит Из ДопРеквизиты Цикл
				Если Реквизит.ЗаполнятьОбязательно
					И УправлениеСвойствами.ЗначениеСвойства(Ссылка, Реквизит) = Неопределено Тогда
					
					Результат.Добавить(Ссылка);
					
					Прервать;
					
				КонецЕсли;
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
