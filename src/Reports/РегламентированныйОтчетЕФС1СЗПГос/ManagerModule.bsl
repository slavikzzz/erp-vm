#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция ВерсияФорматаВыгрузки(Знач НаДату = Неопределено, ВыбраннаяФорма = Неопределено) Экспорт
	
	Возврат Перечисления.ВерсииФорматовВыгрузки.ВерсияЕФСПФР;
	
КонецФункции

Функция ТаблицаФормОтчета() Экспорт
	
	ОписаниеТиповСтрока = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(0));
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("Дата"));
	ОписаниеТиповДата = Новый ОписаниеТипов(МассивТипов, , Новый КвалификаторыДаты(ЧастиДаты.Дата));
	
	ТаблицаФормОтчета = Новый ТаблицаЗначений;
	ТаблицаФормОтчета.Колонки.Добавить("ФормаОтчета",        ОписаниеТиповСтрока);
	ТаблицаФормОтчета.Колонки.Добавить("ОписаниеОтчета",     ОписаниеТиповСтрока, "Утверждена",  20);
	ТаблицаФормОтчета.Колонки.Добавить("ДатаНачалоДействия", ОписаниеТиповДата,   "Действует с", 5);
	ТаблицаФормОтчета.Колонки.Добавить("ДатаКонецДействия",  ОписаниеТиповДата,   "         по", 5);
	ТаблицаФормОтчета.Колонки.Добавить("РедакцияФормы",      ОписаниеТиповСтрока, "Редакция формы", 20);
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2024Кв1";
	НоваяФорма.ОписаниеОтчета
	= "Приложение № 1 к приказу Фонда пенсионного и социального страхования Российской Федерации от 17.11.2023 № 2281.";
	НоваяФорма.РедакцияФормы      = "от 17.11.2023 № 2281.";
	НоваяФорма.ДатаНачалоДействия = '20230101';
	НоваяФорма.ДатаКонецДействия  = РегламентированнаяОтчетностьКлиентСервер.ПустоеЗначениеТипа(Тип("Дата"));
	
	Возврат ТаблицаФормОтчета;
	
КонецФункции

Функция ДеревоФормИФорматов() Экспорт
	
	ФормыИФорматы = Новый ДеревоЗначений;
	ФормыИФорматы.Колонки.Добавить("Код");
	ФормыИФорматы.Колонки.Добавить("ДатаПриказа");
	ФормыИФорматы.Колонки.Добавить("НомерПриказа");
	ФормыИФорматы.Колонки.Добавить("ДатаНачалаДействия");
	ФормыИФорматы.Колонки.Добавить("ДатаОкончанияДействия");
	ФормыИФорматы.Колонки.Добавить("ИмяОбъекта");
	ФормыИФорматы.Колонки.Добавить("Описание");
	
	ФормаОтчета2024Кв1 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы,
	"ЕФС1СЗГ", '2023-11-17', "2281", "ФормаОтчета2024Кв1");
	ОпределитьФорматВДеревеФормИФорматов(ФормаОтчета2024Кв1, "1.19");
	
	ФормаОтчета2023Кв1 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы,
	"ЕФС1СЗГ", '2022-10-31', "245п", "ФормаОтчета2023Кв1");
	ОпределитьФорматВДеревеФормИФорматов(ФормаОтчета2023Кв1, "1.18");
	
	Возврат ФормыИФорматы;
	
КонецФункции

Функция ОпределитьФормуВДеревеФормИФорматов(ДеревоФормИФорматов, Код, ДатаПриказа = '00010101', НомерПриказа = "",
			ИмяОбъекта = "", ДатаНачалаДействия = '00010101', ДатаОкончанияДействия = '00010101', Описание = "")
	
	НовСтр = ДеревоФормИФорматов.Строки.Добавить();
	НовСтр.Код = СокрЛП(Код);
	НовСтр.ДатаПриказа = ДатаПриказа;
	НовСтр.НомерПриказа = СокрЛП(НомерПриказа);
	НовСтр.ДатаНачалаДействия = ДатаНачалаДействия;
	НовСтр.ДатаОкончанияДействия = ДатаОкончанияДействия;
	НовСтр.ИмяОбъекта = СокрЛП(ИмяОбъекта);
	НовСтр.Описание = СокрЛП(Описание);
	Возврат НовСтр;
	
КонецФункции

Функция ОпределитьФорматВДеревеФормИФорматов(Форма, Версия, ДатаПриказа = '00010101', НомерПриказа = "",
			ДатаНачалаДействия = Неопределено, ДатаОкончанияДействия = Неопределено, ИмяОбъекта = "", Описание = "")
	
	НовСтр = Форма.Строки.Добавить();
	НовСтр.Код = СокрЛП(Версия);
	НовСтр.ДатаПриказа = ДатаПриказа;
	НовСтр.НомерПриказа = СокрЛП(НомерПриказа);
	НовСтр.ДатаНачалаДействия = ?(ДатаНачалаДействия = Неопределено, Форма.ДатаНачалаДействия, ДатаНачалаДействия);
	НовСтр.ДатаОкончанияДействия = ?(ДатаОкончанияДействия = Неопределено, Форма.ДатаОкончанияДействия, ДатаОкончанияДействия);
	НовСтр.ИмяОбъекта = СокрЛП(ИмяОбъекта);
	НовСтр.Описание = СокрЛП(Описание);
	Возврат НовСтр;
	
КонецФункции

Функция СведенияПоЗарегистрированнымЛицамИзОтчетовЕФС1СЗПГос(СтруктураПараметров) Экспорт
	
	МассивДанныхОтчетов = Новый Массив;
	
	ИсточникОтчета = "РегламентированныйОтчетЕФС1СЗПГос";
	
	ДатаОкончания = НачалоДня(КонецМесяца(СтруктураПараметров.ДатаОкончания));
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РегламентированныйОтчет.Ссылка,
	|	РегламентированныйОтчет.ВыбраннаяФорма,
	|	РегламентированныйОтчет.Вид КАК Вид
	|ИЗ
	|	Документ.РегламентированныйОтчет КАК РегламентированныйОтчет
	|ГДЕ
	|	РегламентированныйОтчет.ИсточникОтчета = &ИсточникОтчета
	|	И РегламентированныйОтчет.Организация = &Организация
	|	И РегламентированныйОтчет.ДатаОкончания = &ДатаОкончания
	|	И НЕ РегламентированныйОтчет.ПометкаУдаления
	|	И ВЫРАЗИТЬ(РегламентированныйОтчет.ВыбраннаяФорма КАК СТРОКА(18)) = &ИмяФормы
	|
	|УПОРЯДОЧИТЬ ПО
	|	Вид ВОЗР";
	
	Если СтруктураПараметров.Свойство("ПоискПоИмениФормыОтчета")
		И НЕ СтруктураПараметров["ПоискПоИмениФормыОтчета"] Тогда
		
		Запрос.Текст = СтрЗаменить(
		Запрос.Текст, "И ВЫРАЗИТЬ(РегламентированныйОтчет.ВыбраннаяФорма КАК СТРОКА(18)) = &ИмяФормы", "");
		
	Иначе
		
		ИмяФормы = Неопределено;
		СтруктураПараметров.Свойство("ИмяФормыОтчета", ИмяФормы);
		
		Если ИмяФормы = Неопределено Тогда
			ИмяФормы = РегламентированнаяОтчетностьВызовСервера.ИмяФормыРеглОтчетаДействующейВОтчетномПериоде(
			ИсточникОтчета, ДатаОкончания);
		КонецЕсли;
		
		Если ИмяФормы = Неопределено Тогда
			
			Возврат МассивДанныхОтчетов;
			
		КонецЕсли;
		
		Запрос.УстановитьПараметр("ИмяФормы", ИмяФормы);
		
	КонецЕсли;
	
	Запрос.УстановитьПараметр("ИсточникОтчета", ИсточникОтчета);
	Запрос.УстановитьПараметр("ДатаОкончания",  ДатаОкончания);
	Запрос.УстановитьПараметр("Организация",    СтруктураПараметров.Организация);
	
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		
		ИмяРаздела = "Раздел1";
		Выборка = Результат.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			Если ВРег(СокрЛП(Выборка.ВыбраннаяФорма)) = ВРег("ФормаОтчета2024Кв1")
				ИЛИ ВРег(СокрЛП(Выборка.ВыбраннаяФорма)) = ВРег("ФормаОтчета2023Кв1") Тогда
				
				ДанныеОтчета = Выборка.Ссылка.ДанныеОтчета.Получить();
				
				Если НЕ ДанныеОтчета.Свойство("ОкружениеСохранения") Тогда
					
					СтруктураДанныхОтчета = Новый Структура;
					СтруктураДанныхОтчета.Вставить("НомерКорректировки", Выборка.Вид);
					СтруктураДанныхОтчета.Вставить("СведенияПоЗЛ",
					ДанныеОтчета.ДанныеМногоуровневыхРазделов[ИмяРаздела]);
					
					МассивДанныхОтчетов.Добавить(СтруктураДанныхОтчета);
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат МассивДанныхОтчетов;
	
КонецФункции

#КонецОбласти

#КонецЕсли