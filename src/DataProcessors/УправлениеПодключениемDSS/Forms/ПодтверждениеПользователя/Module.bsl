///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТаймАут 		= Параметры.ТаймАут;
	ТекстВопроса 	= Параметры.ТекстВопроса;
	Заголовок 		= Параметры.Заголовок;
	СписокКоманд 	= Параметры.СписокКоманд;
	РежимДиалога	= Истина;
	РедактированиеТаблицы = Ложь;
	
	Элементы.ГруппаОтображение.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	Если Параметры.ПараметрыПечати <> Неопределено Тогда
		Если ТипЗнч(Параметры.ПараметрыПечати) = Тип("ТабличныйДокумент") Тогда
			ТабДок = Параметры.ПараметрыПечати;
		Иначе
			ТабДок = СформироватьПечатнуюФорму(Параметры.ПараметрыПечати);
		КонецЕсли;
		
		РежимДиалога = Ложь;
		Если НЕ Параметры.Свойство("Редактирование", РедактированиеТаблицы) Тогда
			РедактированиеТаблицы = Ложь;
		КонецЕсли;	
	КонецЕсли;
	
	Если ПустаяСтрока(Заголовок) Тогда
		Заголовок = НСтр("ru = 'Вопрос';
						|en = 'Question'");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ЗаголовокПодтверждения) Тогда
		Элементы.РежимПодтверждения.Заголовок = Параметры.ЗаголовокПодтверждения;
	Иначе
		Элементы.РежимПодтверждения.Видимость = Ложь;
	КонецЕсли;
	
	Для Счетчик = 1 По СписокКоманд.Количество() Цикл
		ИмяКоманды = "КомандаПользователя" + Формат(Счетчик, "ЧЦ=10; ЧГ=0");
		СтрокаКоманды = СписокКоманд[Счетчик - 1];
		НоваяСтрока = ТаблицаКоманд.Добавить();
		НоваяСтрока.ЗначениеКоманды = СтрокаКоманды.Значение;
		НоваяСтрока.ИмяКоманды = ИмяКоманды;
		НоваяСтрока.Заголовок = СтрокаКоманды.Представление;
		НоваяСтрока.Картинка = СтрокаКоманды.Картинка;
		НоваяСтрока.Пометка = СтрокаКоманды.Пометка;
	КонецЦикла;
	
	ПодготовитьФормуВопроса(РежимДиалога, ТекстВопроса);
	НастроитьВидимостьЭлементов(РежимДиалога, РедактированиеТаблицы);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПодключитьОбработчикОжидания("Подключаемый_ИзменитьРазмерыФормы", 0.2, Истина);
	
	Если ЗначениеЗаполнено(ТаймАут) Тогда
		ПодключитьОбработчикОжидания("Подключаемый_ЗакрытьФорму", ТаймАут, Истина);
	КонецЕсли;
	
	Если Элементы.РежимПодтверждения.Видимость Тогда
		ТекущийЭлемент = Элементы.РежимПодтверждения;
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
										
&НаКлиенте
Процедура ПодтверждениеПриИзменении(Элемент)
	
	Для Каждого СтрокаСписка Из ТаблицаКоманд Цикл
		
		Если СтрокаСписка.Пометка Тогда
			ЭлементКоманды = Элементы[СтрокаСписка.ИмяКоманды];
			ЭлементКоманды.Доступность = Подтверждение;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ЗакрытьФорму(КодВозвратаДиалога.ОК);
	
КонецПроцедуры

&НаКлиенте
Процедура Печать(Команда)
	
	ТабДок.Напечатать(РежимИспользованияДиалогаПечати.Использовать);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Выполняет событие нажатия кнопки
//
// Параметры:
//  Команда - КомандаФормы
//
&НаКлиенте
Процедура Подключаемый_НажатиеКнопки(Команда)
	
	НашлиСтроки = ТаблицаКоманд.НайтиСтроки(Новый Структура("ИмяКоманды", Команда.Имя));
	Если НашлиСтроки.Количество() > 0 Тогда
		ЗначениеКоманды = НашлиСтроки[0].ЗначениеКоманды;
		Если ТипЗнч(ЗначениеКоманды) = Тип("Строка") И СтрНайти(ЗначениеКоманды, "КодВозвратаДиалога.") > 0 Тогда
			ЗначениеКоманды = КодВозвратаДиалога[Сред(ЗначениеКоманды, 20)];
		КонецЕсли;	
		ЗакрытьФорму(ЗначениеКоманды);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ИзменитьРазмерыФормы()
	
	Элементы.ГруппаКомандыФормы.Видимость = НЕ Элементы.ГруппаКомандыФормы.Видимость;
	Элементы.ГруппаОтображение.Видимость = НЕ Элементы.ГруппаОтображение.Видимость;
	
	Элементы.ГруппаКомандыФормы.Видимость = НЕ Элементы.ГруппаКомандыФормы.Видимость;
	Элементы.ГруппаОтображение.Видимость = НЕ Элементы.ГруппаОтображение.Видимость;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЗакрытьФорму()
	
	ЗакрытьФорму(КодВозвратаДиалога.Таймаут);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(РезультатВыбора = "")
	
	Закрыть(РезультатВыбора);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьВидимостьЭлементов(РежимДиалога, РедактированиеТаблицы)
	
	Элементы.Продолжить.Видимость = ТаблицаКоманд.Количество() = 0; 
	Элементы.ГруппаОтображение.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	Элементы.ДекорацияКартинкаОписания.Видимость = НЕ Элементы.ДекорацияКартинкаОписания.Картинка.Вид = ВидКартинки.Пустая;
	Элементы.ДекорацияКартинка.Видимость = НЕ Элементы.ДекорацияКартинка.Картинка.Вид = ВидКартинки.Пустая;
	Элементы.ГруппаОтобразитьОписание.Видимость = ЗначениеЗаполнено(Элементы.ДекорацияОписание.Заголовок);
	
	Если НЕ РежимДиалога Тогда
		Элементы.ГруппаОтображение.ТекущаяСтраница = Элементы.ГруппаПечатнаяОбласть;
		
	Иначе
		Элементы.ГруппаОтображение.ТекущаяСтраница = Элементы.ГруппаОписание;
		
		Если ТабДок.МасштабПечати = 100 Тогда
			ТабДок.АвтоМасштаб = Истина;
		КонецЕсли;
		ТабДок.ОтображатьЗаголовки = Ложь;
		ТабДок.ОтображатьСетку = Ложь;
		ТабДок.Защита = Ложь;
		ТабДок.ТолькоПросмотр = Истина;
		Элементы.ТабДок.Редактирование = РедактированиеТаблицы;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПодготовитьФормуВопроса(РежимДиалога, ВходнойТекст)
	
	ЕстьПодтверждение = Элементы.РежимПодтверждения.Видимость;
	
	Если РежимДиалога Тогда
		Элементы.ДекорацияИнформация.Заголовок = ВходнойТекст;
		Элементы.ДекорацияКартинка.Картинка = ПолучитьРесурсФормы("ДиалогВопрос");
		
	ИначеЕсли ЗначениеЗаполнено(ВходнойТекст) Тогда
		Элементы.ДекорацияОписание.Заголовок = ВходнойТекст;
		Элементы.ДекорацияКартинкаОписания.Картинка = ПолучитьРесурсФормы("ДиалогИнформация");
		
	КонецЕсли;	
	
	ПервыйЭлемент = Неопределено;
	
	Для Счетчик = 1 По ТаблицаКоманд.Количество() Цикл
		СтрокаКоманды = ТаблицаКоманд[Счетчик - 1];
		ИмяКоманды = СтрокаКоманды.ИмяКоманды;
		
		НоваяКоманда = Команды.Добавить(ИмяКоманды);
		НоваяКоманда.Действие = "Подключаемый_НажатиеКнопки"; 
		НоваяКоманда.Заголовок = СтрокаКоманды.Заголовок;
		Если ЗначениеЗаполнено(СтрокаКоманды.Картинка) Тогда
			НоваяКоманда.Картинка = СтрокаКоманды.Картинка;
		КонецЕсли;
		
		НовыйЭлемент = Элементы.Добавить(ИмяКоманды, Тип("КнопкаФормы"), Элементы.ГруппаКомандыФормы);
		НовыйЭлемент.ИмяКоманды = ИмяКоманды;
		
		Если ЕстьПодтверждение И СтрокаКоманды.Пометка Тогда
			НовыйЭлемент.Доступность = Ложь;
		КонецЕсли;
		
		Если ПервыйЭлемент = Неопределено ИЛИ СтрокаКоманды.Пометка Тогда
			ПервыйЭлемент = НовыйЭлемент;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ПервыйЭлемент <> Неопределено Тогда
		ПервыйЭлемент.КнопкаПоУмолчанию = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СформироватьПечатнуюФорму(ПараметрыПечати)
	
	Результат = Новый ТабличныйДокумент;
	МакетПечати = Обработки.УправлениеПодключениемDSS.ПолучитьМакет("ПодключениеУчетнойЗаписиDSS");
	
	МакетШапки = МакетПечати.ПолучитьОбласть("Заголовок");
	МакетШапки.Параметры.Сервер = ПараметрыПечати.Сервер;
	МакетШапки.Параметры.Логин = ПараметрыПечати.Логин;
	Результат.Вывести(МакетШапки);
	
	Если ПараметрыПечати.Свойство("Пароль") Тогда
		МакетШапки = МакетПечати.ПолучитьОбласть("Логин");
		МакетШапки.Параметры.Пароль = ПараметрыПечати.Пароль;
		Результат.Вывести(МакетШапки);
	КонецЕсли;	
	
	Если ПараметрыПечати.Свойство("ДанныеКлюча") Тогда
		МакетШапки = МакетПечати.ПолучитьОбласть("Ключ");
		КартинкаКода = МакетШапки.Рисунки.ВекторАутентификации;
		КартинкаКода.Линия = Новый Линия(ТипЛинииРисункаТабличногоДокумента.НетЛинии);
		КартинкаКода.Картинка = Новый Картинка(ПараметрыПечати.ДанныеКлюча);
		Результат.Вывести(МакетШапки);
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьРесурсФормы(ИмяРесурса)
	
	Результат = Новый Картинка();
	НашлиРесурс = Новый Структура(ИмяРесурса);
	
	Попытка
		ЗаполнитьЗначенияСвойств(НашлиРесурс, БиблиотекаКартинок);
	Исключение
		Результат = Новый Картинка();
	КонецПопытки;
	
	Если НашлиРесурс[ИмяРесурса] <> Неопределено Тогда
		Результат = НашлиРесурс[ИмяРесурса];
	КонецЕсли;
		
	Возврат Результат;  
	
КонецФункции

#КонецОбласти
