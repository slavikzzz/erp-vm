
#Область ОбработчикиСобытийФормы

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьСрокПредставленияОтчетности(Форма)
	
	ПоследнийМесяцПериода = Месяц(Форма.мДатаКонцаПериодаОтчета);
	ГодПериода = Год(Форма.мДатаКонцаПериодаОтчета);
	СтрСрокПредставления = "Не позднее ";
	Если ПоследнийМесяцПериода = 12 Тогда
		// Годовой Отчет.
		ДатаСрокаПредставления = Дата(ГодПериода + 1, 3, 25);
		СтрСрокПредставления = СтрСрокПредставления + Формат(ДатаСрокаПредставления,
		"ДФ=""дд ММММ гггг 'года'""") + " (п.3 ст.284.12 НК РФ)";
	ИначеЕсли ПоследнийМесяцПериода % 3 = 0 Тогда
		// Для унификации структуры процедуры с другими отчетами.
		// Квартал, полугодие, 9 месяцев.
		ДатаСрокаПредставления = Дата(ГодПериода, ПоследнийМесяцПериода + 1, 25);
		СтрСрокПредставления = СтрСрокПредставления + Формат(ДатаСрокаПредставления,
		"ДФ=""дд ММММ гггг 'года'""") + " (п.3 ст.284.12 НК РФ)";
	Иначе
		// Помесячно.
		ДатаСрокаПредставления = Дата(ГодПериода, ПоследнийМесяцПериода + 1, 25);
		СтрСрокПредставления = СтрСрокПредставления + Формат(ДатаСрокаПредставления,
		"ДФ=""дд ММММ гггг 'года'""") + " (п.3 ст.284.12 НК РФ)";
	КонецЕсли;
	
	Возврат НСтр("ru='" + СтрСрокПредставления + ".'");
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ПоказатьПериод(Форма)
	
	ОбработкаПериодичностьОтчета(Форма);
	
	Если Форма.ГраницыПервогоНалоговогоПериода <> Неопределено
		И Форма.мДатаКонцаПериодаОтчета < НачалоГода(Форма.ГраницыПервогоНалоговогоПериода.Конец)
		И Форма.Элементы.ПолеВыбораПериодичностиПоказаПериода.СписокВыбора.Количество() = 4 Тогда
		Форма.Элементы.ПолеВыбораПериодичностиПоказаПериода.СписокВыбора.Удалить(0);
		Форма.Элементы.ПолеВыбораПериодичностиПоказаПериода.СписокВыбора.Удалить(0);
	КонецЕсли;
	
	Форма.НадписьСрокПредставленияОтчета = ПолучитьСрокПредставленияОтчетности(Форма);
	
	КоличествоФорм = РегламентированнаяОтчетностьКлиентСервер.КоличествоФормСоответствующихВыбранномуПериоду(Форма);
	Если КоличествоФорм >= 1 Тогда
		
		Форма.Элементы.ПолеРедакцияФормы.Видимость = КоличествоФорм > 1;
		УстановитьДоступностьЭлементаПриРасширенномПервомНалоговомПериоде(Форма, "ОткрытьФормуОтчета");
		
	Иначе
		
		Форма.Элементы.ПолеРедакцияФормы.Видимость    = Ложь;
		Форма.Элементы.ОткрытьФормуОтчета.Доступность = Ложь;
		
		Форма.ОписаниеНормативДок = "Отсутствует в программе.";
		
	КонецЕсли;
	
	Форма.Элементы.ОткрытьФормуОтчета.КнопкаПоУмолчанию = Форма.Элементы.ОткрытьФормуОтчета.Доступность;
	
	УстановитьДоступностьЭлементаПриРасширенномПервомНалоговомПериоде(Форма, "УстановитьПредыдущийПериод");
	
	ОтобразитьПоясненияКПериодуОтчета(Форма);
	
	РегламентированнаяОтчетностьКлиентСервер.ВыборФормыРегламентированногоОтчетаПоУмолчанию(Форма);
	
	Форма.Элементы.ПолеРедакцияФормы.СписокВыбора.Очистить();
	
	Для Каждого ЭлФорма Из Форма.РезультирующаяТаблица Цикл
		Форма.Элементы.ПолеРедакцияФормы.СписокВыбора.Добавить(ЭлФорма.РедакцияФормы);
	КонецЦикла;
	
	Форма.НадписьКтоСдаетОтчет = НСтр("ru = 'Только организации.';
										|en = 'Только организации.'");
	
	// Для периодов ранее 2013 года ссылку Изменения законадательства скрываем.
	ГодПериода = Год(Форма.мДатаКонцаПериодаОтчета);
	Форма.Элементы.ПолеСсылкаИзмененияЗаконодательства.Видимость = ГодПериода > 2012;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьПериод(Форма, Шаг)
	
	Если Форма.ПолеВыбораПериодичность = Форма.ПеречислениеПериодичностьКвартал Тогда
		Форма.мДатаКонцаПериодаОтчета  = КонецКвартала(ДобавитьМесяц(Форма.мДатаКонцаПериодаОтчета, Шаг * 3));
		Форма.мДатаНачалаПериодаОтчета = НачалоГода(Форма.мДатаКонцаПериодаОтчета);
	Иначе
		Форма.мДатаКонцаПериодаОтчета  = КонецМесяца(ДобавитьМесяц(Форма.мДатаКонцаПериодаОтчета, Шаг));
		Форма.мДатаНачалаПериодаОтчета = НачалоГода(Форма.мДатаКонцаПериодаОтчета);
	КонецЕсли;
	
	ПоказатьПериод(Форма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбработкаПериодичностьОтчета(Форма)
	
	Форма.Элементы.ПолеВыбораПериодичностиПоказаПериода.СписокВыбора.Очистить();
	
	ДатаКонца  = КонецКвартала(Форма.мДатаКонцаПериодаОтчета);
	ДатаНачала = НачалоГода(Форма.мДатаНачалаПериодаОтчета);
	
	ВремДатаКонца = ДобавитьМесяц(ДатаКонца, - 2);
	
	Если Месяц(ВремДатаКонца) = 1 Тогда
		СтрПериодОтчета = Формат(ВремДатаКонца, "ДФ=""ММММ гггг ' г.'""");
	Иначе
		СтрПериодОтчета = Формат(ДатаНачала, "ДФ=""ММММ гггг ' г.'""")
		+ " - " + Формат(ВремДатаКонца, "ДФ=""ММММ гггг ' г.'""");
	КонецЕсли;
	
	Форма.Элементы.ПолеВыбораПериодичностиПоказаПериода.СписокВыбора.Добавить(СтрПериодОтчета);
	
	Пока ВремДатаКонца <> ДатаКонца Цикл
		
		ВремДатаКонца = КонецМесяца(ДобавитьМесяц(ВремДатаКонца,1));
		
		Если Месяц(ВремДатаКонца) = 1 Тогда
			СтрПериодОтчета = Формат(ВремДатаКонца, "ДФ=""ММММ гггг ' г.'""");
		Иначе
			СтрПериодОтчета = Формат(ДатаНачала, "ДФ=""ММММ гггг ' г.'""")
			+ " - " + Формат(ВремДатаКонца, "ДФ=""ММММ гггг ' г.'""");
		КонецЕсли;
		
		Форма.Элементы.ПолеВыбораПериодичностиПоказаПериода.СписокВыбора.Добавить(СтрПериодОтчета);
	КонецЦикла;
	
	СтрПериодОтчетаКвартал = ПредставлениеПериода(НачалоДня(ДатаНачала), КонецКвартала(ДатаКонца), "ФП = Истина");
	
	Если СтрПериодОтчетаКвартал <> СтрПериодОтчета Тогда
		Форма.Элементы.ПолеВыбораПериодичностиПоказаПериода.СписокВыбора.Добавить(СтрПериодОтчетаКвартал);
	КонецЕсли;
	
	Если Форма.ПолеВыбораПериодичность = Форма.ПеречислениеПериодичностьКвартал Тогда
		
		СтрПериодОтчета = ПредставлениеПериода(НачалоДня(Форма.мДатаНачалаПериодаОтчета),
		КонецДня(Форма.мДатаКонцаПериодаОтчета), "ФП = Истина");
		
	Иначе
		
		Если Месяц(Форма.мДатаКонцаПериодаОтчета) = 1 Тогда 
			СтрПериодОтчета = Формат(Форма.мДатаКонцаПериодаОтчета, "ДФ=""ММММ гггг ' г.'""");
		Иначе
			СтрПериодОтчета = Формат(ДатаНачала, "ДФ=""ММММ гггг ' г.'""") + " - "
			+ Формат(Форма.мДатаКонцаПериодаОтчета, "ДФ=""ММММ гггг ' г.'""");
		КонецЕсли;
		
	КонецЕсли;
	
	Форма.ПолеВыбораПериодичностиПоказаПериода = СтрПериодОтчета;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Организация              = Параметры.Организация;
	мДатаНачалаПериодаОтчета = Параметры.мДатаНачалаПериодаОтчета;
	мДатаКонцаПериодаОтчета  = Параметры.мДатаКонцаПериодаОтчета;
	мПериодичность           = Параметры.мПериодичность;
	мСкопированаФорма        = Параметры.мСкопированаФорма;
	мСохраненныйДок          = Параметры.мСохраненныйДок;
	
	ЭтаФормаИмя = Строка(ИмяФормы);
	ИсточникОтчета = РегламентированнаяОтчетностьВызовСервера.ИсточникОтчета(ЭтаФормаИмя);
	ЗначениеВДанныеФормы(РегламентированнаяОтчетностьВызовСервера.ОтчетОбъект(ИсточникОтчета).ТаблицаФормОтчета(),
	мТаблицаФормОтчета);
	
	Элементы.ПолеРедакцияФормы.Видимость = НЕ (мТаблицаФормОтчета.Количество() > 1);
	
	УчетПоВсемОрганизациям = РегламентированнаяОтчетность.ПолучитьПризнакУчетаПоВсемОрганизациям();
	Элементы.Организация.ТолькоПросмотр = НЕ УчетПоВсемОрганизациям;
	
	ОргПоУмолчанию = РегламентированнаяОтчетность.ПолучитьОрганизациюПоУмолчанию();
	
	Если НЕ ЗначениеЗаполнено(Организация) И ЗначениеЗаполнено(ОргПоУмолчанию) Тогда
		Организация = ОргПоУмолчанию;
	КонецЕсли;
	
	Элементы.Организация.СписокВыбора.ЗагрузитьЗначения(СписокДоступныхЮридическихЛиц().ВыгрузитьЗначения());
	
	Если Элементы.Организация.СписокВыбора.НайтиПоЗначению(Организация) = Неопределено Тогда
		Организация = Неопределено;
	КонецЕсли;
	
	ДоступныеОрганизацииОтсутствуют = Ложь;
	
	Если Элементы.Организация.СписокВыбора.Количество() = 0 Тогда
		
		ДоступныеОрганизацииОтсутствуют = Истина;
		
		Сообщение = Новый СообщениеПользователю;
		
		Сообщение.ИдентификаторНазначения = УникальныйИдентификатор;
		
		Сообщение.Текст = ДоступныеОрганизацииОтсутствуютТекст();
		
		Сообщение.Сообщить();
		
		Элементы.Организация.КнопкаОткрытия = Ложь;
		
	КонецЕсли;
	
	Если РегламентированнаяОтчетностьВызовСервера.ИспользуетсяОднаОрганизация() Тогда
		
		ОргПоУмолчанию = ОбщегоНазначения.ОбщийМодуль("Справочники.Организации").ОрганизацияПоУмолчанию();
		
		Организация = ОргПоУмолчанию;
		
		Элементы.НадписьОрганизация.Видимость  =  Ложь;
		
	КонецЕсли;
	
	ПеречислениеПериодичностьМесяц   = Перечисления.Периодичность.Месяц;
	ПеречислениеПериодичностьКвартал = Перечисления.Периодичность.Квартал;
	
	Элементы.ПолеВыбораПериодичность.СписокВыбора.Добавить(ПеречислениеПериодичностьМесяц);
	Элементы.ПолеВыбораПериодичность.СписокВыбора.Добавить(ПеречислениеПериодичностьКвартал);
	
	Если НЕ ЗначениеЗаполнено(мДатаНачалаПериодаОтчета) И НЕ ЗначениеЗаполнено(мДатаКонцаПериодаОтчета) Тогда
		мДатаКонцаПериодаОтчета  = КонецМесяца(ДобавитьМесяц(КонецКвартала(ТекущаяДатаСеанса()), - 3));
		мДатаКонцаПериодаОтчета  = Макс(мДатаКонцаПериодаОтчета, КонецГода('20231231'));
		мДатаНачалаПериодаОтчета = НачалоГода(мДатаКонцаПериодаОтчета);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(мПериодичность)
		ИЛИ НЕ (мПериодичность = ПеречислениеПериодичностьМесяц
		ИЛИ мПериодичность = ПеречислениеПериодичностьКвартал) Тогда
		
		мПериодичность = ПеречислениеПериодичностьКвартал;
		
	КонецЕсли;
	
	ПолеВыбораПериодичность = мПериодичность;
	
	ИзменитьПериод(ЭтаФорма, 0);
	
	Если ЗначениеЗаполнено(Организация) Тогда
		
		ПериодичностьПредставленияДекларации = Неопределено;
		
		СведенияОбОрганизации = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(
		Организация, мДатаКонцаПериодаОтчета, "ПериодичностьПредставленияДекларацииПоНалогуНаПрибыль");
		
		Если СведенияОбОрганизации.Свойство(
			"ПериодичностьПредставленияДекларацииПоНалогуНаПрибыль", ПериодичностьПредставленияДекларации)
			И (ПериодичностьПредставленияДекларации = ПеречислениеПериодичностьКвартал
			ИЛИ ПериодичностьПредставленияДекларации = ПеречислениеПериодичностьМесяц) Тогда
			
			мПериодичность = ПериодичностьПредставленияДекларации;
			
			ПолеВыбораПериодичность = мПериодичность;
			
			ИзменитьПериод(ЭтаФорма, 0);
			
		КонецЕсли;
		
		ОбработатьОрганизацию(Организация);
		
	КонецЕсли;
	
	ПолеСсылкаИзмененияЗаконодательства = РегламентированнаяОтчетность.ПредставлениеСсылкиИзмененияЗаконодательства();
	ОбщаяЧастьСсылкиНаИзмененияЗаконодательства
	= РегламентированнаяОтчетность.ОбщаяЧастьСсылкиНаИзмененияЗаконодательства(ИсточникОтчета);
	
	// ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.Новости") Тогда
		
		ИдентификаторыСобытийПриОткрытии = "ПриОткрытии";
		
		МодульОбработкаНовостей = ОбщегоНазначения.ОбщийМодуль("ОбработкаНовостей");
		
		МодульОбработкаНовостей.КонтекстныеНовости_ПриСозданииНаСервере(
		ЭтаФорма,
		"БП.Отчет.РегламентированныйОтчетДоходыЛичногоФонда",
		"ОсновнаяФорма",
		,
		НСтр("ru = 'Новости: Расчет доли доходов личного фонда';
			|en = 'Новости: Расчет доли доходов личного фонда'"),
		Ложь,
		Новый Структура("ПолучатьНовостиНаСервере, ХранитьМассивНовостейТолькоНаСервере", Истина, Ложь),
		ИдентификаторыСобытийПриОткрытии);
		
	КонецЕсли;
	// Конец ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеВыбораПериодичностиПоказаПериодаПриИзменении(Элемент)
	
	СтрВыбораПериодичностиПоказаПериода = ПолеВыбораПериодичностиПоказаПериода;
	
	СтрПериодОтчетаГод
	= ПредставлениеПериода(НачалоГода(мДатаКонцаПериодаОтчета), КонецГода(мДатаКонцаПериодаОтчета), "ФП = Истина");
	
	Если (СтрНайти(ВРег(СтрВыбораПериодичностиПоказаПериода),"КВАРТАЛ") > 1)
		ИЛИ (СтрНайти(ВРег(СтрВыбораПериодичностиПоказаПериода),"ГОД") > 1)
		ИЛИ (СтрНайти(ВРег(СтрВыбораПериодичностиПоказаПериода),"МЕСЯЦЕВ") > 1)
		ИЛИ (СтрВыбораПериодичностиПоказаПериода = СтрПериодОтчетаГод) Тогда
		
		ПолеВыбораПериодичность = ПеречислениеПериодичностьКвартал;
		
	Иначе
		
		ПолеВыбораПериодичность = ПеречислениеПериодичностьМесяц;
		
	КонецЕсли;
	
	ДатаНачала = "";
	ДатаКонца  = "";
	РегламентированнаяОтчетностьКлиент.ПолучитьНачалоКонецПериода(
	СтрВыбораПериодичностиПоказаПериода, ДатаНачала, ДатаКонца);
	
	Если ПолеВыбораПериодичность = ПеречислениеПериодичностьКвартал Тогда
		
		мДатаКонцаПериодаОтчета  = КонецКвартала(ДатаКонца);
		мДатаНачалаПериодаОтчета = НачалоКвартала(ДатаНачала);
		
	Иначе
		
		мДатаКонцаПериодаОтчета  = КонецМесяца(ДатаКонца);
		мДатаНачалаПериодаОтчета = НачалоМесяца(ДатаНачала);
		
	КонецЕсли;
	
	мПериодичность = ПолеВыбораПериодичность;
	
	ПоказатьПериод(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеРедакцияФормыПриИзменении(Элемент)
	
	СтрРедакцияФормы = ПолеРедакцияФормы;
	ЗаписьПоиска = Новый Структура;
	ЗаписьПоиска.Вставить("РедакцияФормы",СтрРедакцияФормы);
	МассивСтрок = мТаблицаФормОтчета.НайтиСтроки(ЗаписьПоиска);
	
	Если МассивСтрок.Количество() > 0 Тогда
		ВыбраннаяФорма      = МассивСтрок[0];
		мВыбраннаяФорма     = ВыбраннаяФорма.ФормаОтчета;
		ОписаниеНормативДок = ВыбраннаяФорма.ОписаниеОтчета;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПредыдущийПериод(Команда)
	
	ИзменитьПериод(ЭтаФорма, - 1);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСледующийПериод(Команда)
	
	ИзменитьПериод(ЭтаФорма, 1);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуОтчета(Команда)
	
	Если ДоступныеОрганизацииОтсутствуют Тогда
		ПоказатьПредупреждение(, ДоступныеОрганизацииОтсутствуютТекст());
		Возврат;
	КонецЕсли;
	
	Если мСкопированаФорма <> Неопределено Тогда
		Если мВыбраннаяФорма <> мСкопированаФорма Тогда
			ПоказатьПредупреждение(,НСтр("ru = 'Форма отчета изменилась, копирование невозможно!';
										|en = 'Форма отчета изменилась, копирование невозможно!'"));
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1';
				|en = '%1'"), РегламентированнаяОтчетностьКлиент.ОсновнаяФормаОрганизацияНеЗаполненаВывестиТекст()));
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("мДатаНачалаПериодаОтчета", мДатаНачалаПериодаОтчета);
	ПараметрыФормы.Вставить("мСохраненныйДок",          мСохраненныйДок);
	ПараметрыФормы.Вставить("мСкопированаФорма",        мСкопированаФорма);
	ПараметрыФормы.Вставить("мДатаКонцаПериодаОтчета",  мДатаКонцаПериодаОтчета);
	ПараметрыФормы.Вставить("мПериодичность",           мПериодичность);
	ПараметрыФормы.Вставить("Организация",              Организация);
	ПараметрыФормы.Вставить("мВыбраннаяФорма",          мВыбраннаяФорма);
	ПараметрыФормы.Вставить("ДоступенМеханизмПечатиРеглОтчетностиСДвухмернымШтрихкодомPDF417",
	РегламентированнаяОтчетностьКлиент.ДоступенМеханизмПечатиРеглОтчетностиСДвухмернымШтрихкодомPDF417());
	
	ОткрытьФорму(СтрЗаменить(ИмяФормы, "ОсновнаяФорма", "") + мВыбраннаяФорма, ПараметрыФормы, , Истина);
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьФорму(Команда)
	
	ДопТекстОписания = НСтр("ru = 'Расчет доли доходов личного фонда представляют организации.';
							|en = 'Расчет доли доходов личного фонда представляют организации.'");
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьФормуЗавершение", ЭтотОбъект);
	РегламентированнаяОтчетностьКлиент.ВыбратьФормуОтчетаИзДействующегоСписка(ЭтаФорма, ОписаниеОповещения, ДопТекстОписания);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьФормуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		мВыбраннаяФорма = Результат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	СписокВыбора = СписокДоступныхЮридическихЛиц(Текст);
	
	Если СписокВыбора.Количество() > 0 И ЗначениеЗаполнено(Текст) Тогда
		ДанныеВыбора = СписокВыбора;
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ДоступныеОрганизацииОтсутствуют Тогда
		
		ПоказатьПредупреждение(, ДоступныеОрганизацииОтсутствуютТекст());
		
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияОткрытие(Элемент, СтандартнаяОбработка)
	
	Текст = ВРег(СокрЛП(Элементы.Организация.ТекстРедактирования));
	
	Если НЕ (ЗначениеЗаполнено(Текст) И ЗначениеЗаполнено(Организация)) Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СписокДоступныхЮридическихЛиц(Знач Текст = Неопределено)
	
	СписокВыбора = Новый СписокЗначений;
	РегламентированнаяОтчетность.ПолучитьСписокДоступныхЮридическихЛиц(СписокВыбора, Текст);
	
	Возврат СписокВыбора;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ДоступныеОрганизацииОтсутствуютТекст()
	
	Возврат НСтр(
	"ru = 'Расчет доли доходов личного фонда представляют только организации.
	|В справочнике ""Организации"" сведения об организациях отсутствуют.';
	|en = 'Расчет доли доходов личного фонда представляют только организации.
	|В справочнике ""Организации"" сведения об организациях отсутствуют.'");
	
КонецФункции

&НаКлиенте
Процедура ПолеСсылкаИзмененияЗаконодательстваНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Если ОбщаяЧастьСсылкиНаИзмененияЗаконодательства = "" Тогда
		Возврат;
	КонецЕсли; 
	СсылкаИзмененияЗаконодательства = ОбщаяЧастьСсылкиНаИзмененияЗаконодательства
	+ ОнлайнСервисыРегламентированнойОтчетностиКлиент.ПостфиксСсылки(мДатаКонцаПериодаОтчета);
	ОнлайнСервисыРегламентированнойОтчетностиКлиент.ПопытатьсяПерейтиПоНавигационнойСсылке(СсылкаИзмененияЗаконодательства);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если Параметр = "Активизировать" Тогда
		Если ИмяСобытия = Заголовок Тогда
			Активизировать();
		КонецЕсли;
	КонецЕсли;
	
	// ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.Новости") Тогда
		
		МодульОбработкаНовостейКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбработкаНовостейКлиент");
		
		МодульОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник);
		
	КонецЕсли;
	// Конец ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.Новости") Тогда
		
		МодульОбработкаНовостейКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбработкаНовостейКлиент");
		
		МодульОбработкаНовостейКлиент.КонтекстныеНовости_ПриОткрытии(ЭтаФорма);
		
	КонецЕсли;
	// Конец ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОткорректироватьНачальныйПериод(Форма)
	
	Если Форма.ГраницыПервогоНалоговогоПериода <> Неопределено Тогда
		
		КонецПервогоНалоговогоПериода = Форма.ГраницыПервогоНалоговогоПериода.Конец;
		
		Если Форма.ПолеВыбораПериодичность = Форма.ПеречислениеПериодичностьКвартал Тогда
			КонецПервогоОтчетногоПериода = КонецКвартала(НачалоГода(КонецПервогоНалоговогоПериода));
		Иначе
			КонецПервогоОтчетногоПериода = КонецМесяца(НачалоГода(КонецПервогоНалоговогоПериода));
		КонецЕсли;
		
		Если Форма.мДатаКонцаПериодаОтчета <= КонецПервогоОтчетногоПериода Тогда
			
			Форма.мДатаКонцаПериодаОтчета  = КонецПервогоОтчетногоПериода;
			Форма.мДатаНачалаПериодаОтчета = НачалоГода(Форма.мДатаКонцаПериодаОтчета);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьЭлементаПриРасширенномПервомНалоговомПериоде(Форма, ИмяЭлемента)
	
	ЭлементФормы = Форма.Элементы.Найти(ИмяЭлемента);
	
	Если ЭлементФормы <> Неопределено Тогда
		
		ЭлементФормы.Доступность = НЕ (Форма.ГраницыПервогоНалоговогоПериода <> Неопределено
		И Форма.мДатаКонцаПериодаОтчета < НачалоГода(Форма.ГраницыПервогоНалоговогоПериода.Конец));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Организация = ВыбранноеЗначение;
	
	ОбработатьОрганизацию(Организация);
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьОрганизацию(ВыбОрганизация)
	
	ГраницыПервогоНалоговогоПериода = Неопределено;
	
	Если ЗначениеЗаполнено(ВыбОрганизация) Тогда
		
		ДатаРегистрацииОрганизации = РегламентированнаяОтчетность.ДатаРегистрацииОрганизации(ВыбОрганизация);
		
		ПервыйНалоговыйПериод
		= ИнтерфейсыВзаимодействияБРО.БлижайшийНалоговыйПериод(ВыбОрганизация, ДатаРегистрацииОрганизации,
		Перечисления.ВариантыРасширенногоПервогоНалоговогоПериода.РегистрацияВДекабре);
		
		КонецПервогоНалоговогоПериода = КонецДня(ПервыйНалоговыйПериод.Конец);
		НачалоПервогоНалоговогоПериода = НачалоДня(Мин(ПервыйНалоговыйПериод.Начало, ПервыйНалоговыйПериод.Период));
		
		Если КонецПервогоНалоговогоПериода >= КонецГода('20171231')
			И КонецГода(НачалоПервогоНалоговогоПериода) < КонецПервогоНалоговогоПериода Тогда
			
			ГраницыПервогоНалоговогоПериода
			= Новый Структура("Начало, Конец", НачалоПервогоНалоговогоПериода, КонецПервогоНалоговогоПериода);
			
		КонецЕсли;
		
	КонецЕсли;
	
	ОткорректироватьНачальныйПериод(ЭтаФорма);
	
	ПоказатьПериод(ЭтаФорма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОтобразитьПоясненияКПериодуОтчета(Форма)
	
	Элементы = Форма.Элементы;
	
	ПризнакВидимости = Ложь;
	
	Если Форма.ГраницыПервогоНалоговогоПериода <> Неопределено Тогда
		
		// Случай расширенного первого налогового периода.
		//
		Если КонецГода(Форма.мДатаКонцаПериодаОтчета) < Форма.ГраницыПервогоНалоговогоПериода.Конец
			И КонецГода(ДобавитьМесяц(Форма.мДатаКонцаПериодаОтчета, 1)) = Форма.ГраницыПервогоНалоговогоПериода.Конец Тогда
			
			// Выбран период, предшествующий первому налоговому периоду.
			//
			ПризнакВидимости = Истина;
			
			ШаблонСообщения = НСтр(
			"ru = 'Расчет доли доходов личного фонда за %1 сдавать не нужно. Период с даты регистрации %2 по %3 включается в расчеты за отчетные периоды %4.';
			|en = 'Расчет доли доходов личного фонда за %1 сдавать не нужно. Период с даты регистрации %2 по %3 включается в расчеты за отчетные периоды %4.'");
			
			Если Форма.ПолеВыбораПериодичность = Форма.ПеречислениеПериодичностьКвартал Тогда
				ТекстОтчетногоПериода = Формат(Форма.мДатаКонцаПериодаОтчета, "ДФ='гггг ''год'''");
			Иначе
				ТекстОтчетногоПериода = Формат(Форма.мДатаНачалаПериодаОтчета, "ДФ=""ММММ""")
				+ " - " + Формат(Форма.мДатаКонцаПериодаОтчета, "ДФ=""ММММ гггг 'года'""");
				ТекстОтчетногоПериода = НРег(ТекстОтчетногоПериода);
			КонецЕсли;
			
			ТекстПояснения
			= СтрШаблон(ШаблонСообщения, ТекстОтчетногоПериода,
			Формат(Форма.ГраницыПервогоНалоговогоПериода.Начало, "ДЛФ=D"), Формат(Форма.мДатаКонцаПериодаОтчета, "ДЛФ=D"),
			Формат(Форма.ГраницыПервогоНалоговогоПериода.Конец, "ДФ='гггг ''года'''"));
			
			Элементы.ПояснениеРасширенныйНалоговыйПериод.Заголовок = ТекстПояснения;
			
		ИначеЕсли КонецГода(Форма.мДатаКонцаПериодаОтчета) = Форма.ГраницыПервогоНалоговогоПериода.Конец Тогда
			
			// Выбран период, соответствующий первому налоговому периоду.
			//
			ПризнакВидимости = Истина;
			
			ШаблонСообщения = НСтр("ru = 'Период с даты регистрации %1 по %2 включается в расчет доли доходов личного фонда за %3.';
									|en = 'Период с даты регистрации %1 по %2 включается в расчет доли доходов личного фонда за %3.'");
			
			МесяцКонцаПериодаОтчета = Месяц(Форма.мДатаКонцаПериодаОтчета);
			
			Если Форма.ПолеВыбораПериодичность = Форма.ПеречислениеПериодичностьКвартал Тогда
				Если МесяцКонцаПериодаОтчета = 12 Тогда
					ТекстОтчетногоПериода = Формат(Форма.мДатаКонцаПериодаОтчета, "ДФ='гггг ''год'''");
				Иначе
					ТекстОтчетногоПериода = ПредставлениеПериода(
					НачалоДня(Форма.мДатаНачалаПериодаОтчета), КонецДня(Форма.мДатаКонцаПериодаОтчета), "ФП = Истина");
					ДлинаТекстаОтчетногоПериода = СтрДлина(ТекстОтчетногоПериода);
					ТекстОтчетногоПериода = Лев(ТекстОтчетногоПериода, ДлинаТекстаОтчетногоПериода - 2) + "года";
				КонецЕсли;
			Иначе
				Если МесяцКонцаПериодаОтчета = 1 Тогда
					ТекстОтчетногоПериода = Формат(Форма.мДатаНачалаПериодаОтчета, "ДФ=""ММММ гггг 'года'""");
				Иначе
					ТекстОтчетногоПериода = Формат(Форма.мДатаНачалаПериодаОтчета, "ДФ=""ММММ""")
					+ " - " + Формат(Форма.мДатаКонцаПериодаОтчета, "ДФ=""ММММ гггг 'года'""");
				КонецЕсли;
				ТекстОтчетногоПериода = НРег(ТекстОтчетногоПериода);
			КонецЕсли;
			
			ТекстПояснения = СтрШаблон(ШаблонСообщения, Формат(Форма.ГраницыПервогоНалоговогоПериода.Начало, "ДЛФ=D"),
			Формат(КонецКвартала(Форма.ГраницыПервогоНалоговогоПериода.Начало), "ДЛФ=D"),
			ТекстОтчетногоПериода);
			
			Элементы.ПояснениеРасширенныйНалоговыйПериод.Заголовок = ТекстПояснения;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Элементы.БлокРасширенныйНалоговыйПериод.Видимость = ПризнакВидимости;
	
КонецПроцедуры

#КонецОбласти

#Область Новости

// Процедура показывает новости, требующие прочтения (важные и очень важные)
//
// Параметры:
//  Нет
//
&НаКлиенте
Процедура Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии()
	
	// ИнтернетПоддержкаПользователей.Новости.Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии
	ИдентификаторыСобытийПриОткрытии = "ПриОткрытии";
	// Конец ИнтернетПоддержкаПользователей.Новости.Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.Новости") Тогда
		
		МодульОбработкаНовостейКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбработкаНовостейКлиент");
		
		МодульОбработкаНовостейКлиент.КонтекстныеНовости_ПоказатьНовостиТребующиеПрочтенияПриОткрытии(ЭтаФорма, ИдентификаторыСобытийПриОткрытии);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаКомандыНовости(Команда)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.Новости") Тогда
		
		МодульОбработкаНовостейКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбработкаНовостейКлиент");
		
		МодульОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаКомандыНовости(ЭтаФорма, Команда);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти