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
	
	ЭтоМобильныйКлиент = ОбщегоНазначения.ЭтоМобильныйКлиент();
	
	Настройки = Обработки.ВыполнениеОпераций2_2.ПолучитьНастройкиПользователя();
	
	Если Настройки <> Неопределено Тогда
		
		УчастокВНастройках     = ЗначениеЗаполнено(Настройки.Участок);
		РЦВНастройках          = ЗначениеЗаполнено(Настройки.РабочийЦентр);
		ИсполнительВНастройках = ЗначениеЗаполнено(Настройки.Исполнитель);
		
	КонецЕсли;
	
	УстановитьСвойстваДинамическогоСпискаВыполнениеОпераций();
	
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

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "Запись_ПроизводственнаяОперация2_2"
		И ТипЗнч(Параметр) = Тип("Структура")
		И Параметр.Свойство("Подразделение")
		И Параметр.Подразделение = Подразделение Тогда
		
		Элементы.ВыполнениеОпераций.Обновить();
		
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОперации

&НаКлиенте
Процедура ВыполнениеОперацийПриАктивизацииСтроки(Элемент)
	
	ВыделеноНесколькоОпераций = Элементы.ВыполнениеОпераций.ВыделенныеСтроки.Количество()>1;
	
	Если ЭтоМобильныйКлиент Тогда
		Элементы.НазначитьОперации.Видимость = ВыделеноНесколькоОпераций;
		Элементы.Выбрать.Видимость           = НЕ ВыделеноНесколькоОпераций;
	КонецЕсли;
	
	ВремяВыполнения = 0;
	Если ВыделеноНесколькоОпераций Тогда
	
		Для каждого Строка Из Элементы.ВыполнениеОпераций.ВыделенныеСтроки Цикл
		
			ТекущиеДанные = Элементы.ВыполнениеОпераций.ДанныеСтроки(Строка);
			
			Если ТекущиеДанные.ВремяЕдИзм = ПредопределенноеЗначение("Перечисление.ЕдиницыИзмеренияВремени.Секунда") Тогда
				ВремяВыполнения = ВремяВыполнения + ТекущиеДанные.ВремяВыполненияОжиданиеСоздания/3600;
			ИначеЕсли ТекущиеДанные.ВремяЕдИзм = ПредопределенноеЗначение("Перечисление.ЕдиницыИзмеренияВремени.Минута") Тогда
				ВремяВыполнения = ВремяВыполнения + ТекущиеДанные.ВремяВыполненияОжиданиеСоздания/60;
			ИначеЕсли ТекущиеДанные.ВремяЕдИзм = ПредопределенноеЗначение("Перечисление.ЕдиницыИзмеренияВремени.День") Тогда
				ВремяВыполнения = ВремяВыполнения + ТекущиеДанные.ВремяВыполненияОжиданиеСоздания*24;
			ИначеЕсли ТекущиеДанные.ВремяЕдИзм = ПредопределенноеЗначение("Перечисление.ЕдиницыИзмеренияВремени.Сутки") Тогда
				ВремяВыполнения = ВремяВыполнения + ТекущиеДанные.ВремяВыполненияОжиданиеСоздания*24;
			Иначе
				ВремяВыполнения = ВремяВыполнения + ТекущиеДанные.ВремяВыполненияОжиданиеСоздания;
			КонецЕсли;
		
		КонецЦикла;
		
	КонецЕсли;
	ДополнительнаяЗагрузка(ВремяВыполнения);
	
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
Процедура НазначитьОперацию(Команда)
	
	ВыделенныеСтроки = Элементы.ВыполнениеОпераций.ВыделенныеСтроки;
	
	КлючиОпераций = ПроверитьПолучитьВыделенныеВСпискеОперации(ВыделенныеСтроки);
	
	Если КлючиОпераций = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если КлючиОпераций.Количество() = 1
		И Элементы.ВыполнениеОпераций.ТекущиеДанные <> Неопределено Тогда
		
		Если ТипЗнч(Элементы.ВыполнениеОпераций.ТекущаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка")
			ИЛИ (НЕ ИспользуютсяСменныеЗадания И Элементы.ВыполнениеОпераций.ТекущиеДанные.ОжиданиеСоздания = 0) Тогда
			
			ПоказатьПредупреждение(, НСтр("ru = 'Команда не может быть выполнена для выбранной строки';
											|en = 'Command cannot be executed for the selected line.'"));
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
		
	ОткрытьФормуНазначенияОперации(КлючиОпераций, "Назначить");
	
КонецПроцедуры

&НаКлиенте
Процедура ПропуститьОперацию(Команда)
	
	ВыделенныеСтроки = Элементы.ВыполнениеОпераций.ВыделенныеСтроки;
	
	КлючиОпераций = ПроверитьПолучитьВыделенныеВСпискеОперации(ВыделенныеСтроки);
	
	Если КлючиОпераций = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если КлючиОпераций.Количество() = 1
		И Элементы.ВыполнениеОпераций.ТекущиеДанные <> Неопределено Тогда
		
		Если ТипЗнч(Элементы.ВыполнениеОпераций.ТекущаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			
			ПоказатьПредупреждение(, НСтр("ru = 'Команда не может быть выполнена для выбранной строки';
											|en = 'Command cannot be executed for the selected line.'"));
			Возврат;
		КонецЕсли;
		
		Если НЕ Элементы.ВыполнениеОпераций.ТекущиеДанные.МожноПропустить Тогда
		
			ПоказатьПредупреждение(, НСтр("ru = 'Операция не может быть пропущена';
											|en = 'Operation cannot be skipped'"));
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ОперативныйУчетПроизводстваКлиент.СформироватьПроизводственныеОперации(
			Подразделение,
			КлючиОпераций,
			Новый Структура,
			ПредопределенноеЗначение("Перечисление.СтатусыПроизводственныхОпераций.Пропущена"));
	
КонецПроцедуры

&НаКлиенте
Процедура ПринятьВРаботу(Команда)
	
	ВыделенныеСтроки = Элементы.ВыполнениеОпераций.ВыделенныеСтроки;
	
	КлючиОпераций = ПроверитьПолучитьВыделенныеВСпискеОперации(ВыделенныеСтроки);
	
	Если КлючиОпераций = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если КлючиОпераций.Количество() = 1
		И (Элементы.ВыполнениеОпераций.ТекущиеДанные <> Неопределено) Тогда 
		
		Если ТипЗнч(Элементы.ВыполнениеОпераций.ТекущаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка")
			ИЛИ (НЕ ИспользуютсяСменныеЗадания И Элементы.ВыполнениеОпераций.ТекущиеДанные.МожноВыполнять = 0)
			ИЛИ (ИспользуютсяСменныеЗадания И НЕ Элементы.ВыполнениеОпераций.ТекущиеДанные.МожноНачинать) Тогда
			
			ПоказатьПредупреждение(, НСтр("ru = 'Команда не может быть выполнена для выбранной строки';
											|en = 'Command cannot be executed for the selected line.'"));
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	ОткрытьФормуНазначенияОперации(КлючиОпераций, "ПринятьВРаботу");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтметитьВыполнение(Команда)
	
	ВыделенныеСтроки = Элементы.ВыполнениеОпераций.ВыделенныеСтроки;
	
	КлючиОпераций = ПроверитьПолучитьВыделенныеВСпискеОперации(ВыделенныеСтроки);
	
	Если КлючиОпераций = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если КлючиОпераций.Количество() = 1
		И (Элементы.ВыполнениеОпераций.ТекущиеДанные <> Неопределено) Тогда
		
		ТекущиеДанные = Элементы.ВыполнениеОпераций.ТекущиеДанные;
		
		Если ТипЗнч(Элементы.ВыполнениеОпераций.ТекущаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка")
			ИЛИ (НЕ ИспользуютсяСменныеЗадания И (ТекущиеДанные.МожноВыполнять + ТекущиеДанные.Выполняется) = 0)
			ИЛИ (ИспользуютсяСменныеЗадания И НЕ Элементы.ВыполнениеОпераций.ТекущиеДанные.МожноНачинать) Тогда
			
			ПоказатьПредупреждение(, НСтр("ru = 'Команда не может быть выполнена для выбранной строки';
											|en = 'Command cannot be executed for the selected line.'"));
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	ОткрытьФормуНазначенияОперации(КлючиОпераций, "ОтметитьВыполнение");
	
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

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	// Оформление цветом операций, которые нельзя начинать
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных(Элементы.ВыполнениеОпераций.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ВыполнениеОпераций.МожноНачинать");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.СерыйЦветТекста1);
КонецПроцедуры

&НаКлиенте
Функция ОткрытьФормуНазначенияОперации(КлючиОпераций, РежимРаботы)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Подразделение", Подразделение);
	ПараметрыФормы.Вставить("РежимРаботы", РежимРаботы);
	ПараметрыФормы.Вставить("КлючиОпераций", КлючиОпераций);
	
	Если ЗначениеЗаполнено(РабочийЦентр) Тогда
		ПараметрыФормы.Вставить("РабочийЦентр", РабочийЦентр);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Исполнитель) Тогда
		ПараметрыФормы.Вставить("Исполнитель", Исполнитель);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Участок) Тогда
		ПараметрыФормы.Вставить("Участок", Участок);
	КонецЕсли;
	
	СтатусОперации = Неопределено;
	Если РежимРаботы = "Назначить" Тогда
		СтатусОперации = ПредопределенноеЗначение("Перечисление.СтатусыПроизводственныхОпераций.Создана");
	ИначеЕсли РежимРаботы = "ПринятьВРаботу" Тогда
		СтатусОперации = ПредопределенноеЗначение("Перечисление.СтатусыПроизводственныхОпераций.Выполняется");
	ИначеЕсли РежимРаботы = "ОтметитьВыполнение" Тогда
		СтатусОперации = ПредопределенноеЗначение("Перечисление.СтатусыПроизводственныхОпераций.Выполнена");
	КонецЕсли;
	
	ДопПараметры = Новый Структура;
	ДопПараметры.Вставить("КлючиОпераций", КлючиОпераций);
	ДопПараметры.Вставить("СтатусОперации", СтатусОперации);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ОткрытьФормуНазначениеОперацийЗавершение",
		ЭтотОбъект,
		ДопПараметры);
	
	ОткрытьФорму("Обработка.ВыполнениеОпераций2_2.Форма.НазначениеОпераций",
		ПараметрыФормы,
		ЭтаФорма,
		,
		,
		,
		ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецФункции

&НаКлиенте
Процедура ОткрытьФормуНазначениеОперацийЗавершение(ПараметрыНазначения, ДополнительныеПараметры) Экспорт
	
	Если ПараметрыНазначения <> Неопределено Тогда
		
		ОперативныйУчетПроизводстваКлиент.СформироватьПроизводственныеОперации(
			Подразделение, ДополнительныеПараметры.КлючиОпераций, ПараметрыНазначения, ДополнительныеПараметры.СтатусОперации);
		
		РасчитатьЗагрузку();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСвойстваДинамическогоСпискаВыполнениеОпераций()
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("ОтборПоУчастку", ЗначениеЗаполнено(Участок));
	ПараметрыЗапроса.Вставить("ИспользуютсяСменныеЗадания", ИспользуютсяСменныеЗадания);
	
	СвойстваСписка              = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
	СвойстваСписка.ТекстЗапроса = ТекстЗапросаСпискаВыполнениеОпераций();
	СвойстваСписка.ОсновнаяТаблица = ?(ИспользуютсяСменныеЗадания,
		"РегистрСведений.ОперацииКСозданиюСменныхЗаданий",
		"РегистрСведений.ОчередьПроизводственныхОпераций");
	ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.ВыполнениеОпераций, СвойстваСписка);
	
	Если ЗначениеЗаполнено(Участок) Тогда
		НазначениеОпераций.Параметры.УстановитьЗначениеПараметра("Участок",Участок);
	КонецЕсли;
	
	НазначениеОпераций.Параметры.УстановитьЗначениеПараметра(
		"ИспользуетсяГрафикПроизводства",
		УправлениеПроизводством.ИспользуетсяГрафикПроизводства());
	
	НазначениеОпераций.Параметры.УстановитьЗначениеПараметра(
		"СтатусРабочийГрафик",
		РегистрыСведений.ГрафикЭтаповПроизводства2_2.СтатусРабочийГрафик());
	
	НазначениеОпераций.Порядок.Элементы.Очистить();
	
	Если УправлениеПроизводством.ИспользуетсяГрафикПроизводства() Тогда
	
		ПорядокСписка = НазначениеОпераций.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
		ПорядокСписка.Поле = Новый ПолеКомпоновкиДанных("Порядок");
		ПорядокСписка.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Убыв;
		ПорядокСписка.Использование = Истина;
		
		ПорядокСписка = НазначениеОпераций.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
		ПорядокСписка.Поле = Новый ПолеКомпоновкиДанных("НачалоЭтапа");
		ПорядокСписка.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
		ПорядокСписка.Использование = Истина;
		
		ПорядокСписка = НазначениеОпераций.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
		ПорядокСписка.Поле = Новый ПолеКомпоновкиДанных("НачалоСледующегоЭтапа");
		ПорядокСписка.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
		ПорядокСписка.Использование = Истина;
		
		ПорядокСписка = НазначениеОпераций.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
		ПорядокСписка.Поле = Новый ПолеКомпоновкиДанных("НомерОперации");
		ПорядокСписка.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
		ПорядокСписка.Использование = Истина;
		
	Иначе
		
		ПорядокСписка = НазначениеОпераций.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
		ПорядокСписка.Поле = Новый ПолеКомпоновкиДанных("Порядок");
		ПорядокСписка.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Убыв;
		ПорядокСписка.Использование = Истина;
		
		ПорядокСписка = НазначениеОпераций.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
		ПорядокСписка.Поле = Новый ПолеКомпоновкиДанных("Распоряжение.Приоритет");
		ПорядокСписка.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
		ПорядокСписка.Использование = Истина;
		
		ПорядокСписка = НазначениеОпераций.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
		ПорядокСписка.Поле = Новый ПолеКомпоновкиДанных("Распоряжение.Подразделение.РеквизитДопУпорядочивания");
		ПорядокСписка.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
		ПорядокСписка.Использование = Истина;
		
		ПорядокСписка = НазначениеОпераций.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
		ПорядокСписка.Поле = Новый ПолеКомпоновкиДанных("Распоряжение.Очередь");
		ПорядокСписка.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
		ПорядокСписка.Использование = Истина;
		
		ПорядокСписка = НазначениеОпераций.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
		ПорядокСписка.Поле = Новый ПолеКомпоновкиДанных("ДлительностьДоВыпуска");
		ПорядокСписка.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
		ПорядокСписка.Использование = Истина;
		
		ПорядокСписка = НазначениеОпераций.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
		ПорядокСписка.Поле = Новый ПолеКомпоновкиДанных("НомерОперации");
		ПорядокСписка.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
		ПорядокСписка.Использование = Истина;
	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ТекстЗапросаСпискаВыполнениеОпераций()
	
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	Очередь.Распоряжение КАК Распоряжение,
		|	Очередь.Этап КАК Этап,
		|	&ПредставлениеЭтапа КАК ПредставлениеЭтапа,
		|	Очередь.Подразделение КАК Подразделение,
		|	Очередь.Операция КАК Операция,
		|	Очередь.ИдентификаторОперации КАК ИдентификаторОперации,
		|	ВЫБОР
		|		КОГДА Очередь.Запланировано + Очередь.ТребуетПовторения > Очередь.Создано
		|			ТОГДА Очередь.Запланировано + Очередь.ТребуетПовторения - Очередь.Создано
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК ОжиданиеСоздания,
		|	ВЫБОР
		|		КОГДА Очередь.Запланировано + Очередь.ТребуетПовторения > Очередь.Создано
		|			ТОГДА
		|				ВЫБОР 
		|					КОГДА
		|						ВЫБОР
		|							КОГДА Очередь.Операция.РабочийЦентр ССЫЛКА Справочник.ВидыРабочихЦентров
		|								ТОГДА ЕСТЬNULL(Очередь.Операция.РабочийЦентр.ПараллельнаяЗагрузка, ЛОЖЬ)
		|							ИНАЧЕ ЕСТЬNULL(Очередь.Операция.РабочийЦентр.ВидРабочегоЦентра.ПараллельнаяЗагрузка, ЛОЖЬ)
		|						КОНЕЦ
		|						ТОГДА Очередь.ВремяШтучное
		|					ИНАЧЕ Очередь.ВремяШтучное * (Очередь.Запланировано + Очередь.ТребуетПовторения - Очередь.Создано) / Очередь.Операция.Количество
		|				КОНЕЦ + Очередь.ВремяПЗ
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК ВремяВыполненияОжиданиеСоздания,
		|	Очередь.МожноВыполнять КАК МожноВыполнять,
		|	Очередь.Выполняется КАК Выполняется,
		|	Операции.МожноПропустить КАК МожноПропустить,
		|	Операции.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		|	ВЫБОР
		|		КОГДА Операции.РабочийЦентр ССЫЛКА Справочник.ВидыРабочихЦентров
		|			ТОГДА Операции.РабочийЦентр
		|		ИНАЧЕ Операции.РабочийЦентр.ВидРабочегоЦентра
		|	КОНЕЦ КАК ВидРабочегоЦентра,
		|	ВЫБОР
		|		КОГДА Операции.РабочийЦентр ССЫЛКА Справочник.РабочиеЦентры
		|			ТОГДА Операции.РабочийЦентр
		|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.РабочиеЦентры.ПустаяСсылка)
		|	КОНЕЦ КАК РабочийЦентр,
		|	Операции.ВариантНаладки КАК ВариантНаладки,
		|	Очередь.ВремяОбщее КАК ВремяВыполнения,
		|	Очередь.ВремяЕдИзм КАК ВремяЕдИзм,
		|	Очередь.Порядок КАК Порядок,
		|	ВЫБОР
		|		КОГДА &ИспользуетсяГрафикПроизводства
		|				И НЕ График.ЭтапПроизводства ЕСТЬ NULL
		|			ТОГДА График.НачалоЭтапа
		|		ИНАЧЕ ДОБАВИТЬКДАТЕ(Очередь.Распоряжение.НачатьНеРанее, СЕКУНДА, ЕСТЬNULL(НормативныйГрафик.ДлительностьДоЗапуска, 0))
		|	КОНЕЦ КАК ДатаНачала,
		|	Очередь.НомерОперации КАК НомерОперации,
		|	Очередь.НомерСледующейОперации КАК НомерСледующейОперации,
		|	Операции.Описание КАК Описание,
		|	ВЫБОР
		|		КОГДА Очередь.МожноВыполнять > 0
		|				И Очередь.МожноВыполнять > Очередь.Создано - (Очередь.Выполняется + Очередь.Выполнено + Очередь.Пропущено)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК МожноНачинать,
		|	График.НачалоЭтапа КАК НачалоЭтапа,
		|	График.НачалоСледующегоЭтапа КАК НачалоСледующегоЭтапа,
		|	НормативныйГрафик.ДлительностьДоВыпуска КАК ДлительностьДоВыпуска
		|ИЗ
		|	РегистрСведений.ОчередьПроизводственныхОпераций КАК Очередь
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ТехнологическиеОперации КАК Операции
		|		ПО Очередь.Операция = Операции.Ссылка
		|		{ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ГрафикЭтаповПроизводства2_2 КАК График
		|		ПО Очередь.Распоряжение = График.Распоряжение
		|			И Очередь.Этап = График.ЭтапПроизводства
		|			И (График.СтатусГрафика = &СтатусРабочийГрафик)}
		|		{ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НормативныйГрафикЭтаповПроизводства КАК НормативныйГрафик
		|		ПО Очередь.Этап = НормативныйГрафик.ЭтапПроизводства}
		|ГДЕ
		|	НЕ Очередь.ВАрхиве
		|	И Очередь.Запланировано + Очередь.ТребуетПовторения > Очередь.Создано
		|	И &ТекстОтборПоУчастку
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Очередь.Распоряжение КАК Распоряжение,
		|	Очередь.Этап КАК Этап,
		|	&ПредставлениеЭтапа КАК ПредставлениеЭтапа,
		|	Очередь.Подразделение КАК Подразделение,
		|	Очередь.Операция КАК Операция,
		|	Очередь.ИдентификаторОперации КАК ИдентификаторОперации,
		|	Очередь.Количество КАК ОжиданиеСоздания,
		|	&ВремяВыполненияОжиданиеСоздания КАК ВремяВыполненияОжиданиеСоздания,
		|	NULL КАК МожноВыполнять,
		|	NULL КАК Выполняется,
		|	Операции.МожноПропустить КАК МожноПропустить,
		|	Операции.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		|	ВЫБОР
		|		КОГДА Операции.РабочийЦентр ССЫЛКА Справочник.ВидыРабочихЦентров
		|			ТОГДА Операции.РабочийЦентр
		|		ИНАЧЕ Операции.РабочийЦентр.ВидРабочегоЦентра
		|	КОНЕЦ КАК ВидРабочегоЦентра,
		|	ВЫБОР
		|		КОГДА Операции.РабочийЦентр ССЫЛКА Справочник.РабочиеЦентры
		|			ТОГДА Операции.РабочийЦентр
		|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.РабочиеЦентры.ПустаяСсылка)
		|	КОНЕЦ КАК РабочийЦентр,
		|	Операции.ВариантНаладки КАК ВариантНаладки,
		|	&ВремяВыполнения КАК ВремяВыполнения,
		|	Очередь.ВремяЕдИзм КАК ВремяЕдИзм,
		|	Очередь.Порядок КАК Порядок,
		|	ВЫБОР
		|		КОГДА &ИспользуетсяГрафикПроизводства
		|				И НЕ График.ЭтапПроизводства ЕСТЬ NULL
		|			ТОГДА График.НачалоЭтапа
		|		ИНАЧЕ ДОБАВИТЬКДАТЕ(Очередь.Распоряжение.НачатьНеРанее, СЕКУНДА, ЕСТЬNULL(НормативныйГрафик.ДлительностьДоЗапуска, 0))
		|	КОНЕЦ КАК ДатаНачала,
		|	Очередь.НомерОперации КАК НомерОперации,
		|	Очередь.НомерСледующейОперации КАК НомерСледующейОперации,
		|	Операции.Описание КАК Описание,
		|	Очередь.МожноНазначать КАК МожноНачинать,
		|	График.НачалоЭтапа КАК НачалоЭтапа,
		|	График.НачалоСледующегоЭтапа КАК НачалоСледующегоЭтапа,
		|	НормативныйГрафик.ДлительностьДоВыпуска КАК ДлительностьДоВыпуска
		|ИЗ
		|	РегистрСведений.ОперацииКСозданиюСменныхЗаданий КАК Очередь
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ТехнологическиеОперации КАК Операции
		|		ПО Очередь.Операция = Операции.Ссылка
		|		{ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ГрафикЭтаповПроизводства2_2 КАК График
		|		ПО Очередь.Распоряжение = График.Распоряжение
		|			И Очередь.Этап = График.ЭтапПроизводства
		|			И (График.СтатусГрафика = &СтатусРабочийГрафик)}
		|		{ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НормативныйГрафикЭтаповПроизводства КАК НормативныйГрафик
		|		ПО Очередь.Этап = НормативныйГрафик.ЭтапПроизводства}
		|ГДЕ
		|	Очередь.СменноеЗадание = ЗНАЧЕНИЕ(Документ.СменноеЗадание.ПустаяСсылка)
		|	И &ТекстОтборПоУчастку";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ОБЪЕДИНИТЬ ВСЕ", "~");
	
	Если ИспользуютсяСменныеЗадания Тогда
		
		ТекстЗапроса = СтрРазделить(ТекстЗапроса,"~")[1];
		
		ТекстЗапроса = СтрЗаменить(
			ТекстЗапроса,
			"&ВремяВыполненияОжиданиеСоздания",
			РегистрыСведений.ОперацииКСозданиюСменныхЗаданий.ТекстЗапросаВремяОперации("Очередь"));
		
		ТекстЗапроса = СтрЗаменить(
			ТекстЗапроса,
			"&ВремяВыполнения",
			РегистрыСведений.ОперацииКСозданиюСменныхЗаданий.ТекстЗапросаВремяОперации("Очередь"));
		
	Иначе
		
		ТекстЗапроса = СтрРазделить(ТекстЗапроса,"~")[0];
		
	КонецЕсли;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И &ТекстОтборПоУчастку",
		?(НЕ ЗначениеЗаполнено(Участок), "",
			"	И (Операции.РабочийЦентр = НЕОПРЕДЕЛЕНО
			|		ИЛИ Операции.РабочийЦентр = ЗНАЧЕНИЕ(Справочник.РабочиеЦентры.ПустаяСсылка)
			|		ИЛИ Операции.РабочийЦентр = ЗНАЧЕНИЕ(Справочник.ВидыРабочихЦентров.ПустаяСсылка)
			|		ИЛИ Операции.РабочийЦентр ССЫЛКА Справочник.РабочиеЦентры
			|			И Операции.РабочийЦентр.Участок = &Участок
			|		ИЛИ Операции.РабочийЦентр ССЫЛКА Справочник.ВидыРабочихЦентров
			|			И ИСТИНА В
			|				(ВЫБРАТЬ ПЕРВЫЕ 1
			|					ИСТИНА
			|				ИЗ
			|					Справочник.РабочиеЦентры КАК Т
			|				ГДЕ
			|					Т.ВидРабочегоЦентра = Операции.РабочийЦентр
			|					И Т.Участок = &Участок))"));
	
	Документы.ЭтапПроизводства2_2.ВыполнитьПодстановкуПоляПредставлениеЭтапа(
			ТекстЗапроса,
			"&ПредставлениеЭтапа",
			"Очередь.Этап");
	
	Возврат ТекстЗапроса;
	
КонецФункции

#Область Отборы

&НаКлиенте
Процедура УстановитьОтборыКлиент(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	УстановитьОтборы(Результат, ДополнительныеПараметры);
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборы(Результат = Неопределено, ДополнительныеПараметры = Неопределено)
	
	Если Результат <> Неопределено Тогда
		
		МожноВыполнять = Результат.МожноВыполнять;
		ВидРЦ          = Результат.ВидРЦ;
		РабочийЦентр   = Результат.РабочийЦентр;
		Исполнитель    = Результат.Исполнитель;
		Операция       = Результат.Операция;
		Изделие        = Результат.Изделие;
		Партия         = Результат.Партия;
		Этап           = Результат.Этап;
		Участок        = Результат.Участок;
	
	КонецЕсли;
	
	ОтборыСтрока = "";
	
	УстановитьОтборМожноВыполнять();
	УстановитьОтборПоЭтапу();
	УстановитьОтборПоПартии();
	УстановитьОтборПоИзделию();
	УстановитьОтборПоОперации();
	ДобавитьВСтрокуОтборов(Исполнитель);
	УстановитьОтборПоРабочемуЦентру();
	УстановитьОтборПоУчастку();
	УстановитьОтборПоПодразделению();
	
	НастроитьЭлементыОтбора();
	
	РасчитатьЗагрузку()
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборМожноВыполнять()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(НазначениеОпераций,
		"МожноНачинать",
		МожноВыполнять,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		МожноВыполнять);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоПодразделению()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(НазначениеОпераций,
		"Подразделение",
		Подразделение,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(Подразделение));
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоРабочемуЦентру()
	
	Если ЗначениеЗаполнено(РабочийЦентр) Тогда
		
		ПодразделениеРЦ = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(РабочийЦентр,"ВидРабочегоЦентра.Подразделение");
		УчастокРЦ = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(РабочийЦентр,"Участок");
		
		Если ПодразделениеРЦ <> Подразделение
			ИЛИ (ЗначениеЗаполнено(Участок) И УчастокРЦ <> Участок) Тогда
			
			ТекстСообщения = НСтр("ru = 'Выбранный рабочий центр не находится в текущем подразделении или участке';
									|en = 'The selected work center is not in the current business unit or site'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
			
			РабочийЦентр = Неопределено;
			
			Возврат;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ЗначенияРЦ = Новый СписокЗначений;
	ЗначенияРЦ.Добавить(РабочийЦентр);
	ЗначенияРЦ.Добавить(ПредопределенноеЗначение("Справочник.РабочиеЦентры.ПустаяСсылка"));
	ЗначенияРЦ.Добавить(Неопределено);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
	НазначениеОпераций, 
	"РабочийЦентр", 
	ЗначенияРЦ, 
	ВидСравненияКомпоновкиДанных.ВСписке,
	, 
	ЗначениеЗаполнено(РабочийЦентр));
	
	ЗначенияВРЦ = Новый СписокЗначений;
	ЗначенияВРЦ.Добавить(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(РабочийЦентр,"ВидРабочегоЦентра"));
	ЗначенияВРЦ.Добавить(ПредопределенноеЗначение("Справочник.ВидыРабочихЦентров.ПустаяСсылка"));
	ЗначенияВРЦ.Добавить(Неопределено);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
	НазначениеОпераций, 
	"ВидРабочегоЦентра", 
	ЗначенияВРЦ, 
	ВидСравненияКомпоновкиДанных.ВСписке,
	,
	ЗначениеЗаполнено(РабочийЦентр));
	
	Если НЕ ЗначениеЗаполнено(РабочийЦентр) И ЗначениеЗаполнено(ВидРЦ) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		НазначениеОпераций, 
		"ВидРабочегоЦентра", 
		ЗначенияВРЦ, 
		ВидСравненияКомпоновкиДанных.ВСписке,
		,
		Истина);
		
		ДобавитьВСтрокуОтборов(ВидРЦ);
	КонецЕсли;
	
	ДобавитьВСтрокуОтборов(РабочийЦентр);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоОперации()
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(НазначениеОпераций,
		"Операция",
		Операция,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(Операция));
		
	ДобавитьВСтрокуОтборов(Операция);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоИзделию()
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(НазначениеОпераций,
		"Этап.ПартияПроизводства.ОсновноеИзделиеНоменклатура",
		Изделие,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(Изделие));
		
	ДобавитьВСтрокуОтборов(Изделие);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоПартии()
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(НазначениеОпераций,
		"Этап.ПартияПроизводства",
		Партия,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(Партия));
		
	ДобавитьВСтрокуОтборов(Партия);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоЭтапу()
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(НазначениеОпераций,
		"Этап",
		Этап,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(Этап));
		
	ДобавитьВСтрокуОтборов(Этап);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоУчастку()
	Если НЕ УчастокВНастройках Тогда
	
		УстановитьСвойстваДинамическогоСпискаВыполнениеОпераций();
		
		Элементы.ВыполнениеОпераций.Обновить();
		
	КонецЕсли;
	Если ЗначениеЗаполнено(Участок) Тогда
		ДобавитьВСтрокуОтборов(Участок);
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
		Элементы.СбросОтборов.Видимость = Ложь;
	Иначе
		ОтборыСтрока = Лев(ОтборыСтрока, СтрДлина(ОтборыСтрока)-2);
		Элементы.СбросОтборов.Видимость = Истина;
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
	
	Если Ссылки.Количество() > 0 Тогда
		
		Если ТипЗнч(Ссылки[0]) = Тип("ДокументСсылка.ПроизводственнаяОперация2_2") Тогда
			Возврат Ссылки[0].Операция;
		Иначе
			Возврат Ссылки[0];
		КонецЕсли;
	
	КонецЕсли;
	Возврат Неопределено;

КонецФункции

&НаСервере
Процедура РасчитатьЗагрузку()
	
	Элементы.Загрузка.Видимость = ЗначениеЗаполнено(РабочийЦентр) ИЛИ ЗначениеЗаполнено(Исполнитель);
	
	РассчитаннаяЗагрузка = ОперативныйУчетПроизводства.РассчитатьЗагрузку(РабочийЦентр, Исполнитель, Подразделение);
	
	Если ЗначениеЗаполнено(РабочийЦентр) > 0 Тогда
		
		Загрузка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Загрузка РЦ %1 ч';
				|en = 'Work center load %1 h'"), РассчитаннаяЗагрузка.РабочийЦентр);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Исполнитель) > 0 Тогда
		
		Если ЗначениеЗаполнено(РабочийЦентр) Тогда
		
			Загрузка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1, исполнителя %2 ч';
				|en = '%1, assignee %2 h'"),Загрузка, РассчитаннаяЗагрузка.Исполнитель);
			
		Иначе
		
			Загрузка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Загрузка исполнителя %1 ч';
					|en = 'Assignee import %1 h'"), РассчитаннаяЗагрузка.Исполнитель);
		
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДополнительнаяЗагрузка(ВремяВыполнения)
	
	НеИспольнительИРЦ = НЕ (ЗначениеЗаполнено(Исполнитель) И ЗначениеЗаполнено(РабочийЦентр));
	
	ПозицияЗнакаПодстроки = СтрНайти(Загрузка,"(");
	
	Если ПозицияЗнакаПодстроки > 0 Тогда
		
		Если НеИспольнительИРЦ Тогда
			Загрузка = Лев(Загрузка,ПозицияЗнакаПодстроки - 2) + Символы.НПП + НСтр("ru = 'ч';
																					|en = 'h'");
		Иначе
			Загрузка = Лев(Загрузка,ПозицияЗнакаПодстроки - 2);
		КонецЕсли;
		
	КонецЕсли;
	
	Если ВремяВыполнения > 0 Тогда
		
		Если НеИспольнительИРЦ Тогда
			
			ПозицияЗнакаПодстроки = СтрНайти(Загрузка,НСтр("ru = 'ч';
															|en = 'h'"));
			
			Загрузка = Лев(Загрузка,ПозицияЗнакаПодстроки - 2) + " (+" + Окр(ВремяВыполнения,2) + НСтр("ru = ') ч';
																										|en = ') h'");
			
		Иначе
			
			Загрузка = Загрузка + " (+" + Окр(ВремяВыполнения,2) + ")";
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПроверитьПолучитьВыделенныеВСпискеОперации(ВыделенныеСтроки)
	
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		
		Результат = Неопределено;
		
		ПоказатьПредупреждение(, НСтр("ru = 'Не выбраны операции для выполнения действия';
										|en = 'Operations to execute the action are not selected'"));
		
	Иначе
		
		Результат = Новый Массив;
		
		Для каждого Строка Из ВыделенныеСтроки Цикл
			
			Если ТипЗнч(Строка) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
				
				ПоказатьПредупреждение(, НСтр("ru = 'Действие не может быть выполнено для строки группировки списка';
												|en = 'Action cannot be executed for the list grouping row'"));
				
				Результат = Неопределено;
				Прервать;
				
			Иначе
				
				Результат.Добавить(Строка);
				
			КонецЕсли;
		
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
